@extends('layouts.trade')
@section('content')

<link rel="stylesheet" type="text/css" href="{{ asset('/trade_asset/css/simulator.css') }}">
<style>
    table.data-table tbody td.symbol {
        position: -webkit-sticky;
        position: sticky;
        top: 0;
        background: #fbfdfe;
        color: #000;
        left: 0;
        z-index: 1;
    }
</style>


<section class="pt-10">
<div class="container">

 @php
        $sectors = getSectorList();
    @endphp 
    <div class="scanner-body relative"> 
         
        <div class="d-flex flex-wrap gap-3 justify-between align-center mt-1 mb-2"> 
        <h1 class="text-50 weight-600 color-secondary">Top Losers</h1>
        <div class="d-flex flex-direction-column">
        <div class="tile d-flex gap-1 mb-1 flex-wrap align-end scanner-status-txt ">
        <div class="text-12 weight-600">Market Status : <span id="marketStatus" class="weight-400"></span> </div><div class="text-12 sap-devider">|</div><div class="text-12 weight-600"> Last Updated : <span id="lastUpdated" class="weight-400"></span></div>
        </div> 
        <?php
        // Get the 'shortBy' query parameter
        $shortBy = isset($_GET['shortBy']) ? $_GET['shortBy'] : 1; // Default to 1 if not set
        ?>

       <div class="d-flex flex-wrap gap-1 align-center">
            <a class="text-20 white-btn d-flex gap-1" href="{{ url('market-scanner') }}"><i class="fa-solid fa-magnifying-glass-chart color-secondary"></i> Scanner </a>
            <a class="text-20 white-btn d-flex gap-1" href="{{ url('market-scanner/topGainer?shortBy=2') }}"><i class="fa-solid fa-arrow-trend-up color-green"></i> Gainers </a>
            <a class="text-20 white-btn d-flex gap-1 active-btn" href="{{ url('market-scanner/topLoser?shortBy=2') }}"><i class="fa-solid fa-arrow-trend-down color-red"></i> Losers </a> 

            <div class="shortDiv bg-white ml-1 radius-6 shodow-9">
               <a style="display:none" class="text-12 d-inline-block white-btn sub-tabsbtn <?php echo ($shortBy == 1) ? 'active' : ''; ?>" href="javascript:void(0);" data-id=1 direction='up'><i class="fa-solid fa-sort"></i> Net Change</a>
                <a class="text-12 d-inline-block white-btn sub-tabsbtn <?php echo ($shortBy == 2) ? 'active' : ''; ?>" href="javascript:void(0);" data-id=2 direction='up'><i class="fa-solid fa-sort"></i> Percent Change</a>
                <a class="text-12 d-inline-block white-btn sub-tabsbtn <?php echo ($shortBy == 3) ? 'active' : ''; ?>" href="javascript:void(0);" data-id=3 direction='up'><i class="fa-solid fa-sort"></i> Volume</a>
            </div>
            <!-- <a class="gradiant-btn" id="streamBtn" href="javascript:void(0);" onclick="processBatch();"><i class="fa-solid fa-circle-play"></i> Start Stream</a> -->
        </div>
    </div> 
        </div>




        <section class="bg-white-50 shodow-9 mt-2 border-1-white"> 
            <!-- SECTOR Table -->
            <div class="responsive-table" style="min-height:100px;">
                <table class="data-table">
                    <thead>
                        <tr> 
                            <th class="sortable" data-column="symbol">Symbol</th>
                            <th class="sortable" data-column="company">Company Name</th>
                            <th class="sortable" data-column="sector">Sector</th> 
                            <th class="sortable" data-column="lastTrade">Last Trade</th>
                            <th class="sortable" data-column="netChange">Net Change</th>
                            <th class="sortable" data-column="perChange">% Change</th>
                            <th class="sortable" data-column="volume">Volume</th> 
                            <th class="sortable" data-column="dollarVolume">$ Volume</th>
                        </tr>
                    </thead> 
                    <tbody id="tableBody">
                        <div id="loader" class="loader-overlay hidden">
                            <div class="spinner"></div>
                            <br /><div class="loader-content">Please wait while we are fetching stocks list.</div>
                        </div>
                    </tbody>
                </table> 
            </div> 
        </section>
    </div>
</div>

</section>
<style>  
.cursor, table.data-table thead th{cursor:pointer;}
.scanner-table table th, .responsive-table table td {
    padding: 6px 18px;
}
.responsive-table table td a{color:var(--colorPrimary); text-decoration:none; }
</style>
 
@endsection
@section('my-scripts')

<script> 

 $(document).ready(function() {
    setTimeout(function() {
        location.reload(true);
    }, 60000); // 240000 milliseconds = 4 minutes
}); 

function displayCurrentDateTimeInET() {
    const now = new Date();
    const options = {
        timeZone: 'America/New_York',
        year: '2-digit',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: true
    };
    const formattedDateTime = new Intl.DateTimeFormat('en-US', options).format(now);

    // Safely set the content if the element exists
    const lastUpdatedElement = document.getElementById('lastUpdated');
    if (lastUpdatedElement) {
        lastUpdatedElement.textContent = formattedDateTime;
    }
}

    let intervalId = '';
    $(document).ready(function () {
        intervalId = setInterval(displayCurrentDateTimeInET, 1000);
        $("#lastUpdated").hide();
        setTimeout(function() {
            $("#lastUpdated").show();
        }, 6000);  
        processBatch();         
    });
    let prChangeAr = [];   
    $(document).ready(function () { 
        processBatch(); 
        $(".shortDiv a").click(function(event) {            
            event.preventDefault(); // Prevent the default behavior of the link
            const shortIndex = $(this).data("id"); // Get the value of the data-id attribute 
            // Get the current URL
            const url = new URL(window.location.href);  
            // Set or update the 'shortBy' query parameter
            url.searchParams.set('shortBy', shortIndex);  
            // Update the URL in the browser without reloading the page
            window.history.replaceState(null, '', url.toString());   
            // Reload the page
            location.reload(true);
        });  
    });  

    // Retrieve the URL parameter 'shortBy'
    const urlParams = new URLSearchParams(window.location.search);
    const shortByValue = urlParams.get('shortBy');
    // Set the default value to 1 if 'shortBy' is not present in the URL
    let shortIndex = shortByValue ? parseInt(shortByValue) : 1;
  

    var eventSource = null;     
    // Sort the table based on column and direction 
    function sortTable(column, direction) {
        const rows = Array.from(document.querySelector("table tbody").rows);
        
        rows.sort((rowA, rowB) => {
            const cellA = rowA.querySelector(`td.${column}`).textContent.trim();
            const cellB = rowB.querySelector(`td.${column}`).textContent.trim();

            // Attempt to convert the cell values into numbers for numeric columns
            const numA = parseFloat(cellA.replace(/[^0-9.-]+/g, ""));
            const numB = parseFloat(cellB.replace(/[^0-9.-]+/g, ""));

            // Compare numbers first, otherwise fall back to string comparison
            if (direction === 'asc') {
                if (!isNaN(numA) && !isNaN(numB)) {
                    return numA - numB;  // Sort as numbers
                }
                return cellA.localeCompare(cellB);  // Sort as strings
            } else {
                if (!isNaN(numA) && !isNaN(numB)) {
                    return numB - numA;  // Sort as numbers in reverse
                }
                return cellB.localeCompare(cellA);  // Sort as strings in reverse
            }
        });

        // Rebuild the table with sorted rows
        const tbody = document.querySelector("table tbody");
        rows.forEach(row => tbody.appendChild(row)); // Append rows in sorted order
    }

    // Add event listeners to column headers for sorting
    document.querySelectorAll('.sortable').forEach(header => {
        header.addEventListener('click', function () {
            const column = header.getAttribute('data-column');
            const currentDirection = header.getAttribute('data-sort-direction') || 'asc';
            const newDirection = currentDirection === 'asc' ? 'desc' : 'asc';

            // Update the direction in the header
            header.setAttribute('data-sort-direction', newDirection);

            // Call the sorting function
            sortTable(column, newDirection);
            closeAllEventSources();
        });
    });

    function renderOffLine(data) {   
       
        if (Array.isArray(data) && data.length > 0) { 
            clearInterval(intervalId);           
            $("#lastUpdated").html(data[0].closeDate+" "+data[0].time);
            $("#marketStatus").html('Closed');
            $("tbody").empty();
            $("#streamBtn").hide();
            data.forEach(function (item, index) {              
                if (item && item.Identifier && item.change < 0) {   
                    
                    const bid = '$' + (item.bid || 0);
                    const ask = '$' + (item.ask || 0);

                    let lastTrade = (item.price || 0);
                    let netChange =  (item.change || 0);
                    let perChange = item.changesPercentage || 0;
                    const volume = item.volume || 0;

                    let time = item.time || ""; // Ensure it exists
                    let timeWithoutMilliseconds = time.split(".")[0]; // Default: Remove milliseconds from regular time

                    // Updated dollarVolume calculation
                    var dollarVolume = '$' + ((volume || 0) * (lastTrade || 0)).toFixed(2);

                    var row = document.querySelector(`table tr[data-symbol="${item.Identifier}"]`);

                    // Function to determine color based on value
                    function getColorClass(value) {
                        return value < 0 ? 'color-red' : 'color-green';
                    }

                    formattedVolume = volume.toLocaleString(); 
                    var dollarVolume = ((volume || 0) * (lastTrade || 0)).toFixed(2);     
                    var formattedDollarVolume = '$' + Number(dollarVolume).toLocaleString(); 

                        if (lastTrade !== 0) {
                            if (!row) {
                                row = document.createElement("tr");
                                row.setAttribute("data-symbol", item.Identifier);
                                row.innerHTML = `         
                                    <td class="symbol">${item.Identifier}</td>
                                    <td class="symbol">${item.name}</td> 
                                    <td class="sector">${item.sector}</td> 
                                    <td class="lastTrade">$${lastTrade}</td>
                                    <td class="netChange ${getColorClass(netChange)}">$${netChange}</td>
                                    <td class="perChange ${getColorClass(perChange)}">${perChange}</td>
                                    <td class="volume">${formattedVolume}</td> 
                                    <td class="dollarVolume">${formattedDollarVolume}</td>
                                `;
                                document.querySelector("table tbody").appendChild(row);
                            } else { 
                                row.querySelector(".symbol").innerHTML = `${item.Identifier}`;
                                row.querySelector(".company").innerHTML = `${item.name}`;                                
                                row.querySelector(".sector").textContent = item.sector; 
                                row.querySelector(".lastTrade").textContent = `$${lastTrade}`; 
                                row.querySelector(".netChange").textContent = '$'+netChange;
                                row.querySelector(".netChange").className = `netChange ${getColorClass(netChange)}`;
                                row.querySelector(".perChange").textContent = perChange;
                                row.querySelector(".perChange").className = `perChange ${getColorClass(perChange)}`;
                                row.querySelector(".volume").textContent = formattedVolume; 
                                row.querySelector(".dollarVolume").textContent = formattedDollarVolume;
                            }
                        }
                  
                } else {
                    console.warn("Invalid item or missing Identifier:", item);
                }
            });
            $("#loader").css('display','none'); 
        } else {
            console.warn("No valid data received:", data);
        }
    } 


    let eventSources = [];    
    function processBatch() {

        const loader = document.getElementById("loader");
        if (loader) {
            loader.classList.remove("hidden"); // Remove the hidden class to show the loader
        }

        const fetchDataOffLineData = async () => { 
            try {
                const response = await fetch('https://dev.stocks.news:8080/topLoser?shortBy=' + shortIndex); 
                if (response.ok) {
                    const data = await response.json(); // Parse the JSON response
                    dataReceived = true; // Set the flag to true when data is received 
                    offlineData = true;
                    renderOffLine(data); 
                } else {
                    console.error(`Error fetching data from ${url}`);
                }
            } catch (err) {
                console.error("Error:", err);
            }
        }; 


        const urls = [];

        for (let port = 8021; port <= 8040; port++) {
            urls.push(`https://dev.stocks.news:${port}/sse`);
        }
        
        let isFetchDataOfflineCalled = false; 
        // Loop over each URL and create an EventSource and its listeners dynamically
        urls.forEach((url, index) => {
             
            const eventSource = new EventSource(url);
            eventSources.push(eventSource);  // Store the event source for later use (e.g., to close all connections later)

            const checkInterval = 5000; // Interval in milliseconds to check for data
            // Start a timeout to check if no data is received
            const noDataTimeout = setTimeout(() => {  
                if (!isFetchDataOfflineCalled) {
                     fetchDataOffLineData();
                     isFetchDataOfflineCalled = true; // Set the flag to true 
                }                 
            }, checkInterval); 

            eventSource.addEventListener('open', function () {
                console.log(`Connected to ${url}`);
            });
        
            eventSource.onmessage = function(event) {
                // Parse the received data (assumed to be JSON)
                isFetchDataOfflineCalled = true; 
                const data = JSON.parse(event.data); 
                dataReceived = true; // Mark that data has been received
                clearTimeout(noDataTimeout); // Clear the timeout since data is received                          
                renderData2(data); 
            };
        
            eventSource.addEventListener('error', function (event) {
                console.error(`Error in connection to ${url}`);
                eventSource.close();
            });
        }); 
    }

    // Optionally, you can close all event sources when done
    // This is just an example, you can call it when you need to close the connections.
    function closeAllEventSources() {
        eventSources.forEach((eventSource) => {
            eventSource.close();
        }); 
    }   
       
    function renderData2(data) {          
        if (Array.isArray(data) && data.length > 0) {
            data.sort(function (a, b) {
                return (b.PercentChange || 0) - (a.PercentChange || 0); // Sorting by perChange (ascending)
            });

            data.forEach(function (item, index) {                 
                if (item && item.Identifier) {
                   
                    const ExtendedHoursType = item.ExtendedHoursType || "";
                    if (item.Volume == 0) {
                        return true;
                    }
                    if (ExtendedHoursType === "PostMarket" || ExtendedHoursType === "PreMarket") {
                        if (item.Volume * item.ExtendedHoursPrice < 100000) {
                            return true;
                        }
                    }else{
                        if (item.Volume * item.Last < 100000) {
                            return true;
                        }
                    } 
                    let lastUpdated =   item.Date +  item.Time;
                    let lastTrade = (item.Last || 0);
                    let netChange =  (item.Change || 0);
                    let perChange = item.PercentChange || 0; 
                    const volume = item.Volume || 0;
 
                   
                    let extendedHoursTime = ""; // Declare extendedHoursTime here
                    $("#marketStatus").html(ExtendedHoursType); 
                    if (ExtendedHoursType === "PostMarket" || ExtendedHoursType === "PreMarket") {
                        netChange = item.ExtendedHoursChange || 0;
                        perChange = item.ExtendedHoursPercentChange || 0; 
                    } else{
                        $("#marketStatus").html('Live');
                    }     
                    if(netChange>0){
                        return true;
                    }
                    $("#lastUpdated").html(item.stockLastUpdatedDateTime);
                    var symbol = item.Identifier;    
                     // Check if the symbol already exists in prChangeAr array
                    let existingIndex = prChangeAr.findIndex(function (entry) {
                        return entry[0] === symbol; // Check if the symbol exists
                    });
                    const companyName = item.Security?.Name || "Unknown";
                    // If the symbol does not exist, push it to the array
                    if (existingIndex === -1) {
                        prChangeAr.push([symbol,netChange,perChange,volume,item.sector,lastTrade,companyName]);  // Push symbol and perChange
                    } else {
                        // Optionally, update perChange for the existing symbol if needed
                        if(shortIndex==1){
                            prChangeAr[existingIndex][1] = netChange;
                        }
                        if(shortIndex==2){
                            prChangeAr[existingIndex][2] = perChange;
                        }  
                        if(shortIndex==3){
                            prChangeAr[existingIndex][3] = volume;
                        }                        
                    } 
                } else {
                    console.warn("Invalid item or missing Identifier:", item);
                }
            }); 
            // Sort the array by perChange in ascending order
            prChangeAr.sort(function(a, b) {
                return a[shortIndex] - b[shortIndex]; 
            });

            // Slice the top 50 items (top 50 symbols)
            const top50Symbols = prChangeAr.slice(0, 50); 
            // Get the table body element
            const tableBody = document.getElementById('tableBody');

            // Clear the current table body content to remove existing rows
            tableBody.innerHTML = '';

            // Loop through the top 50 symbols and create a table row for each
             top50Symbols.forEach((entry) => {
                    //prChangeAr.push([symbol,netChange,perChange,volume,item.sector,lastTrade]);
                    const symbol = entry[0] || 'N/A';
                    const companyName = entry[6] || 'N/A';
                    const sector = entry[4] || 'N/A';                    
                    const lastTrade = entry[5] || 0;
                    const netChange = entry[1] || 0;
                    const perChange = entry[2] || 0;
                    const volume = entry[3] || 0;     
                    
                    formattedVolume = volume.toLocaleString();               
                    var dollarVolume = ((volume || 0) * (lastTrade || 0)).toFixed(2); 
                    var formattedDollarVolume = '$' + Number(dollarVolume).toLocaleString();    

                    let row = document.querySelector(`tr[data-symbol="${symbol}"]`);

                    if (lastTrade !== 0) {
                        if (!row) {
                            row = document.createElement("tr");
                            row.setAttribute("data-symbol", symbol);
                            row.innerHTML = ` 
                                <td class="symbol">${symbol}</td>
                                <td class="company">${companyName}</td> 
                                <td class="sector">${sector}</td>
                                <td class="lastTrade">$${lastTrade}</td>
                                <td class="netChange ${getColorClass(netChange)}">$${netChange}</td>
                                <td class="perChange ${getColorClass(perChange)}">${perChange}</td>
                                <td class="volume">${formattedVolume}</td> 
                                <td class="dollarVolume">${formattedDollarVolume}</td>
                            `;
                            document.querySelector("table tbody").appendChild(row);
                        } else { 
                            row.querySelector(".symbol").innerHTML = `${symbol}`;
                            row.querySelector(".company").innerHTML = `${companyName}`;                            
                            row.querySelector(".sector").textContent = sector; 
                            row.querySelector(".lastTrade").textContent = `$${lastTrade}`;
                            row.querySelector(".netChange").textContent = `$${netChange}`;
                            row.querySelector(".netChange").className = `netChange ${getColorClass(netChange)}`;
                            row.querySelector(".perChange").textContent = `${perChange}`;
                            row.querySelector(".perChange").className = `perChange ${getColorClass(perChange)}`;
                            row.querySelector(".volume").textContent = formattedVolume; 
                            row.querySelector(".dollarVolume").textContent = formattedDollarVolume;
                        }
                    }
                });
            $("#loader").css('display','none'); 
            symboleStatus = 0;
        } else {
            console.warn("No valid data received:", data);
        }
    }

    
    function getColorClass(value) {
                        return value < 0 ? 'color-red' : 'color-green';
                    }

</script>

   

@endsection
