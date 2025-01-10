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

<div class="container ">
    

 @php
        $sectors = getSectorList();
    @endphp 
    <div class="scanner-body relative">

    <div class="d-flex align-center justify-between gap-3 flex-wrap mt-6">
        <h1 class=" text-50 weight-600 color-secondary">Market Scanner</h1>
        
    </div>
    
   <div class="d-flex gap-3 justify-between align-center mt-1 mb-2 filter-nav-wrapper">
        <div class="d-flex align-center justify-between gap-3 grow-1 flex-wrap">
            <div class="d-flex align-center gap-1 flex-wrap filterSection">
                 
            </div> 
        </div>
        <div class="right-filter-nav">
        <div class="tile d-flex gap-1 mb-1 flex-wrap">
            <div class="text-12 weight-600">Market Status : <span id="marketStatus" class="weight-400"></span> </div><div class="text-12 sap-devider">|</div><div class="text-12 weight-600"> Last Updated : <span id="lastUpdated" class="weight-400"></span></div>
        </div> 
        
        <div class="d-flex right-filter-button gap-1 align-center">
            <a class="text-20 white-btn d-flex gap-1 active-btn" href="{{ url('market-scanner') }}"><i class="fa-solid fa-magnifying-glass-chart color-secondary"></i> Scanner </a>
            <a class="text-20 white-btn d-flex gap-1" href="{{ url('market-scanner/topGainer?shortBy=2') }}"><i class="fa-solid fa-arrow-trend-up color-green"></i> Gainers </a>
            <a class="text-20 white-btn d-flex gap-1" href="{{ url('market-scanner/topLoser?shortBy=2') }}"><i class="fa-solid fa-arrow-trend-down color-red"></i> Losers </a>
            <div class="dropdownMenu d-flex flex-wrap ml-1 gap-3" style="align-items: flex-end; position: static;"> 
            <!-- BUTTONS -->
                <button class="text-12 white-btn filterButton"><i class="fa-solid fa-filter"></i><span>&nbsp; Filter</span></button >

                <div id="filterBx"  class="dropdownMenuWrapper d-none absolute">
                <div class="grid-one-one-one gap-2 filter-container bg-white shodow-9 radius-15 border-1-white p-2">
                    <div class="form-group">
                        <label>Bid:</label>
                        <div class="d-flex align-center justify-between gap-1">
                            <input type="number" class="form-input" id="bidStart" placeholder="Bid Start">
                            <input type="number" class="form-input" id="bidEnd" placeholder="Bid End">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Ask:</label>
                        <div class="d-flex align-center justify-between gap-1">
                            <input type="number" class="form-input" id="askStart" placeholder="Ask Start">
                            <input type="number" class="form-input" id="askEnd" placeholder="Ask End">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Last Trade:</label>
                        <div class="d-flex align-center justify-between gap-1">
                            <input type="number" class="form-input" id="lastTradeStart" placeholder="Last Trade Start">
                            <input type="number" class="form-input" id="lastTradeEnd" placeholder="Last Trade End">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Net Change:</label>
                        <div class="d-flex align-center justify-between gap-1">
                            <input type="number" class="form-input" id="netChangeStart" placeholder="Net Change Start">
                            <input type="number" class="form-input" id="netChangeEnd" placeholder="Net Change End">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>% Change:</label>
                        <div class="d-flex align-center justify-between gap-1">
                            <input type="number" class="form-input" id="percentChangeStart" placeholder="% Change Start">
                            <input type="number" class="form-input" id="percentChangeEnd" placeholder="% Change End">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Volume:</label>
                        <div class="d-flex align-center justify-between gap-1">
                            <input type="number" class="form-input" id="volumeStart" placeholder="Volume Start">
                            <input type="number" class="form-input" id="volumeEnd" placeholder="Volume End">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>$ Volume:</label>
                        <div class="d-flex align-center justify-between gap-1">
                            <input type="number" class="form-input" id="dollarVolumeStart" placeholder="$ Volume Start">
                            <input type="number" class="form-input" id="dollarVolumeEnd" placeholder="$ Volume End">
                        </div>
                    </div> 
                    <div class="form-group">
                        <label>Select Sector</label>
                        <select name="sector" id="sector" class="form-input"> 
                          @foreach ($sectors as $key => $sp)
                              <option value="{{ $sp['sector'] }}" >
                                  {{ $sp['sector'] }}
                              </option>
                          @endforeach
                        </select> 
                    </div>
                    <div class="form-group">
                        <label>Symbol Name/Company Name</label>
                        <div class="d-flex align-center justify-between gap-1">
                            <input type="text" class="form-input" id="symbolName" name="symbol" placeholder="Symbol Name/Company Name">  
                        </div>
                    </div>  
                    <div class="form-group">
                        <div class="d-flex align-center justify-between gap-1" style="align-items: flex-end;">
                            <button id="resetFilter" class="gradiant-btn-flat">Reset Filters</button>
                        </div>
                    </div>                       
                </div> 
            </div>
            </div>
        </div> 
        </div>
    </div>
    

            

        <section class="bg-white-50 shodow-9 mt-2 border-1-white">             
            <div class="responsive-table" style="min-height:100px;">
                <table class="data-table">
                    <thead>
                        <tr> 
                            <th class="sortable" data-column="symbol">Symbol</th>
                            <th class="sortable" data-column="company">Company Name</th>
                            <th class="sortable" data-column="sector">Sector</th>
                            <th class="sortable" data-column="bid">Bid</th>
                            <th class="sortable" data-column="ask">Ask</th>
                            <th class="sortable" data-column="lastTrade">Last Trade</th>
                            <th class="sortable" data-column="netChange">Net Change</th>
                            <th class="sortable" data-column="perChange">% Change</th>
                            <th class="sortable" data-column="volume">Volume</th>
                            <th class="sortable" data-column="dollarVolume">$ Volume</th>
                        </tr>
                    </thead> 
                    <tbody>
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
   let defaultSector = "Healthcare";  
    let dataReceived = false; // Flag to track if data has been received
    let offlineData = false; // Flag to track if data has been received
    let intervalId = '';
    let timeoutId; // Declare a variable to store the timeout ID
 $(document).ready(function() {
    timeoutId = setTimeout(function() {
        location.reload(true);
    }, 240000); // 240000 milliseconds = 4 minutes
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


   // window.onload = displayCurrentDateTimeInET;

   
    $(document).ready(function () {
        intervalId = setInterval(displayCurrentDateTimeInET, 1000);
        $("#lastUpdated").hide();
        setTimeout(function() {
            $("#lastUpdated").show();
        }, 6000);  
        processBatch();         
    }); 

    document.addEventListener("DOMContentLoaded", () => {
        // Function to filter rows and update active filters
        function filterRows() {
            const filterSection = document.querySelector(".filterSection");
            filterSection.innerHTML = ""; // Clear existing filters

            const filters = [
                { id: "bidStart", label: "Bid Start" },
                { id: "bidEnd", label: "Bid End" },
                { id: "askStart", label: "Ask Start" },
                { id: "askEnd", label: "Ask End" },
                { id: "lastTradeStart", label: "Last Trade Start" },
                { id: "lastTradeEnd", label: "Last Trade End" },
                { id: "netChangeStart", label: "Net Change Start" },
                { id: "netChangeEnd", label: "Net Change End" },
                { id: "percentChangeStart", label: "Percent Change Start" },
                { id: "percentChangeEnd", label: "Percent Change End" },
                { id: "volumeStart", label: "Volume Start" },
                { id: "volumeEnd", label: "Volume End" },
                { id: "dollarVolumeStart", label: "Dollar Volume Start" },
                { id: "dollarVolumeEnd", label: "Dollar Volume End" },
                { id: "sector", label: "Sector" },
                { id: "symbolName", label: "Symbol" }
            ];

            // Display active filters
            filters.forEach(filter => {
                const value = document.getElementById(filter.id)?.value.trim();
                if (value) {
                    const filterTag = document.createElement("div");
                    filterTag.className = "d-flex align-center tagbx";
                    filterTag.innerHTML = `
                        ${filter.label}: ${value}
                        <span class="close pl-1"><i class="fa-solid fa-times"></i></span>
                    `;

                    // Remove filter on clicking close icon
                    filterTag.querySelector(".close").addEventListener("click", () => {
                        // Clear the input field
                        document.getElementById(filter.id).value = ""; 

                        // If the filter being removed is for 'sector', reset the dropdown to the first option
                        if (filter.id === "sector") {
                            const sectorSelect = document.getElementById("sector");
                            sectorSelect.selectedIndex = 0; // Set the dropdown to the first option
                        } 
                        // Remove the filter tag
                        filterTag.remove(); 
                        // Reapply filters
                        filterRows();
                    }); 
                    filterSection.appendChild(filterTag);
                }
            });

            // Filter table rows
            document.querySelectorAll("table tbody tr").forEach(row => {
                const bid = parseFloat(row.querySelector(".bid")?.textContent.replace("$", "") || 0);
                const ask = parseFloat(row.querySelector(".ask")?.textContent.replace("$", "") || 0);
                const lastTrade = parseFloat(row.querySelector(".lastTrade")?.textContent.replace("$", "") || 0);
                const netChange = parseFloat(row.querySelector(".netChange")?.textContent.replace("$", "") || 0);
                const percentChange = parseFloat(row.querySelector(".perChange")?.textContent.replace("%", "") || 0);
                const volume = parseFloat(row.querySelector(".volume")?.textContent.replace(",", "") || 0);
                const dollarVolume = parseFloat(row.querySelector(".dollarVolume")?.textContent.replace("$", "") || 0);
                const sector = row.querySelector(".sector")?.textContent.trim();
                const symbol = row.querySelector(".symbol")?.textContent.trim();

                const isVisible =
                    (!document.getElementById("bidStart").value || bid >= parseFloat(document.getElementById("bidStart").value)) &&
                    (!document.getElementById("bidEnd").value || bid <= parseFloat(document.getElementById("bidEnd").value)) &&
                    (!document.getElementById("askStart").value || ask >= parseFloat(document.getElementById("askStart").value)) &&
                    (!document.getElementById("askEnd").value || ask <= parseFloat(document.getElementById("askEnd").value)) &&
                    (!document.getElementById("lastTradeStart").value || lastTrade >= parseFloat(document.getElementById("lastTradeStart").value)) &&
                    (!document.getElementById("lastTradeEnd").value || lastTrade <= parseFloat(document.getElementById("lastTradeEnd").value)) &&
                    (!document.getElementById("netChangeStart").value || netChange >= parseFloat(document.getElementById("netChangeStart").value)) &&
                    (!document.getElementById("netChangeEnd").value || netChange <= parseFloat(document.getElementById("netChangeEnd").value)) &&
                    (!document.getElementById("percentChangeStart").value || percentChange >= parseFloat(document.getElementById("percentChangeStart").value)) &&
                    (!document.getElementById("percentChangeEnd").value || percentChange <= parseFloat(document.getElementById("percentChangeEnd").value)) &&
                    (!document.getElementById("volumeStart").value || volume >= parseFloat(document.getElementById("volumeStart").value)) &&
                    (!document.getElementById("volumeEnd").value || volume <= parseFloat(document.getElementById("volumeEnd").value)) &&
                    (!document.getElementById("dollarVolumeStart").value || dollarVolume >= parseFloat(document.getElementById("dollarVolumeStart").value)) &&
                    (!document.getElementById("dollarVolumeEnd").value || dollarVolume <= parseFloat(document.getElementById("dollarVolumeEnd").value)) &&
                    (!document.getElementById("sector").value || sector === document.getElementById("sector").value) &&
                    (!document.getElementById("symbolName").value || symbol.toLowerCase().includes(document.getElementById("symbolName").value.toLowerCase()));
                
                row.style.display = isVisible ? "" : "none";
            });
        }

        // Reset filters function
        function resetFilters() {
            document.querySelectorAll(".filter-container input, .filter-container select").forEach(input => {
                if (input.tagName === "SELECT") {
                    input.selectedIndex = 0; // Reset dropdown to default value
                } else {
                    input.value = ""; // Clear text input fields
                }
                
            });
            filterRows(); // Reapply filters to show all rows
        }

        // Set default sector value and apply filter on page load
        // Set this to your desired default sector value
        document.getElementById("sector").value = defaultSector;
        filterRows();

        // Add event listeners to all filter input fields
        document.querySelectorAll(".filter-container input, .filter-container select").forEach(input => {
            input.addEventListener("input", filterRows);
            input.addEventListener("change", filterRows); // For select elements
        });

        // Add event listener to the reset filter button
        document.getElementById("resetFilter").addEventListener("click", event => {
            event.preventDefault(); // Prevent form submission if button is inside a form
            resetFilters(); // Call resetFilters function
            fetchDataOffLineData('Healthcare');
        });
    });

    // Function to fetch data when the sector changes
    const fetchDataOffLineData = async (selectedValue) => {
        try {
            const response = await fetch('https://dev.stocks.news:8080/getScreener?sector=' + selectedValue); 
            if (response.ok) {
                const data = await response.json(); // Parse the JSON response 
                clearTimeout(timeoutId);
                renderOffLine(data); // Call your function to render the data
                $("#loader").css("display", "none"); // Hide the loader
            } else {
                console.error(`Error fetching data from ${url}`);
            }
        } catch (err) {
            console.error("Error:", err);
        }
    };

    // Trigger fetch when the sector dropdown changes
    $("#sector").change(function() {
        var selectedValue = $(this).val(); // Get the selected value 
        if (offlineData) { // Check if offlineData is true
            $("#loader").css("display", "flex"); // Show the loader while fetching
            fetchDataOffLineData(selectedValue); // Pass selected value to fetchDataOffLineData
        } 
    });


    $("#symbolName").keyup(function() {
        var typedValue = $(this).val(); // Get the typed value
        if(offlineData){
            if (typedValue.length >= 3) {
                const fetchDataOffLineData = async () => {
                    try {
                        const response = await fetch('https://dev.stocks.news:8080/getScreenerBySymbol?symbol=' + typedValue); 
                        if (response.ok) {
                            const data = await response.json(); // Parse the JSON response  
                            renderOffLine(data); 
                        } else {
                            console.error(`Error fetching data from ${url}`);
                        }
                    } catch (err) {
                        console.error("Error:", err);
                    }
                };
                fetchDataOffLineData(); // Call the function on keyup
            }; 
        } 
    });


    var eventSource = null;
    var data = [];
    var token = '';
    let defaulPort = 8080;
    // Sort the table based on column and direction
    function sortTable(column, direction) {
        const rows = Array.from(document.querySelector("table tbody").rows);
        
        rows.sort((rowA, rowB) => {
            const cellA = rowA.querySelector(`td.${column}`).textContent;
            const cellB = rowB.querySelector(`td.${column}`).textContent;

            // Compare as numbers if possible
            const numA = parseFloat(cellA.replace(/[^0-9.-]+/g, ""));
            const numB = parseFloat(cellB.replace(/[^0-9.-]+/g, ""));

            if (direction === 'asc') {
                return isNaN(numA) ? (cellA < cellB ? -1 : 1) : numA - numB;
            } else {
                return isNaN(numA) ? (cellA < cellB ? 1 : -1) : numB - numA;
            }
        }); 
   
        // Rebuild the table with sorted rows
        const tbody = document.querySelector("table tbody");
        rows.forEach(row => tbody.appendChild(row));
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
        });
    });

    function renderOffLine(data) {   
       
        if (Array.isArray(data) && data.length > 0) {  
            clearInterval(intervalId);           
            $("#lastUpdated").html(data[0].closeDate+" "+data[0].time);
            $("#marketStatus").html('Closed');
            $("tbody").empty();
            data.forEach(function (item, index) {              
                if (item && item.Identifier) {   
                    const bid = '$' + (item.bid || 0);
                    const ask = '$' + (item.ask || 0);

                    let lastTrade = (item.price || 0);
                    let netChange =  (item.change || 0);
                    let perChange = item.changesPercentage || 0;
                    const volume = item.volume || 0;

                    let time = item.time || ""; // Ensure it exists
                    let timeWithoutMilliseconds = time.split(".")[0]; // Default: Remove milliseconds from regular time

                    // Updated dollarVolume calculation
                    

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
                                    <td class="symbol">
                                        <a href="/stock-detail/NASDAQ/${item.Identifier}/overview" target="_blank">${item.Identifier}</a>
                                    </td>
                                    <td class="company">
                                        <a href="/stock-detail/NASDAQ/${item.Identifier}/overview" target="_blank">${item.name}</a>
                                    </td>  
                                    <td class="sector">${item.sector}</td>
                                    <td class="bid">${bid}</td>
                                    <td class="ask">${ask}</td>
                                    <td class="lastTrade">$${lastTrade}</td>
                                    <td class="netChange ${getColorClass(netChange)}">$${netChange}</td>
                                    <td class="perChange ${getColorClass(perChange)}">${perChange}</td>
                                    <td class="volume">${formattedVolume}</td>
                                    <td class="dollarVolume">${formattedDollarVolume}</td>
                                `;
                                document.querySelector("table tbody").appendChild(row);
                            } else { 
                                row.querySelector(".symbol").innerHTML = `<a href="/stock-detail/NASDAQ/${item.Identifier}/overview" target="_blank">${item.Identifier}</a>`;
                                row.querySelector(".company").innerHTML =  `<a href="/stock-detail/NASDAQ/${item.Identifier}/overview" target="_blank">${item.name}</a>`;
                                row.querySelector(".sector").textContent = item.sector;
                                row.querySelector(".bid").textContent = bid;
                                row.querySelector(".ask").textContent = ask;
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
     
    function processBatch() {

        const loader = document.getElementById("loader");
        if (loader) {
            loader.classList.remove("hidden"); // Remove the hidden class to show the loader
        }

        const fetchDataOffLineData = async () => {
            console.log("fetchDataOffLineData");
            try {
                const response = await fetch('https://dev.stocks.news:8080/getScreener?sector=Healthcare'); 
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
         
        let eventSources = [];
        
        // Loop over each URL and create an EventSource and its listeners dynamically
        let isFetchDataOfflineCalled = false; 
        urls.forEach((url, index) => {
            console.log(`Connecting to ${url}`);
            
            const eventSource = new EventSource(url);
            eventSources.push(eventSource);  // Store the event source for later use (e.g., to close all connections later)
 
            const checkInterval = 5000; // Interval in milliseconds to check for data
            // Start a timeout to check if no data is received
            const noDataTimeout = setTimeout(() => { 
                console.warn(`Connected to ${url}, but no data received in ${checkInterval / 1000} seconds.`); 
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
                //$("#loader").css('display','none');
            });
        });

        // Optionally, you can close all event sources when done
        // This is just an example, you can call it when you need to close the connections.
        function closeAllEventSources() {
            eventSources.forEach((eventSource) => {
                eventSource.close();
            });
            console.log('All EventSource connections closed');
        }

        // Call closeAllEventSources() when needed (e.g., after some time or on some event)
    }


   function renderData2(data) {   
        if (Array.isArray(data) && data.length > 0) {           
            data.forEach(function (item, index) {    
                
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
                    
                const companyName = item.Security?.Name || "Unknown";
                const bid = '$' + (item.Bid || 0);
                const ask = '$' + (item.Ask || 0);

                let lastTrade = (item.Last || 0);
                let netChange =  (item.Change || 0);
                let perChange = item.PercentChange || 0;
                const volume = item.Volume || 0;

                let time = item.Time || ""; // Ensure it exists
                let timeWithoutMilliseconds = time.split(".")[0]; // Default: Remove milliseconds from regular time

               // let lastUpdated = item.Date;
                
                let extendedHoursTime = ""; // Declare extendedHoursTime here
                $("#marketStatus").html(ExtendedHoursType); 
                if (ExtendedHoursType === "PostMarket" || ExtendedHoursType === "PreMarket") {
                    netChange = item.ExtendedHoursChange || 0;
                    perChange = item.ExtendedHoursPercentChange || 0;
                    lastTrade = item.ExtendedHoursPrice || 0;
                    extendedHoursTime = item.ExtendedHoursTime || "";
                   // lastUpdated = item.ExtendedHoursDate;
                    // Use extended hours time instead of regular time
                    timeWithoutMilliseconds = extendedHoursTime.split(".")[0];
                }else{
                    $("#marketStatus").html("Live");
                }   
                // Updated dollarVolume calculation 

                var row = document.querySelector(`table tr[data-symbol="${item.Identifier}"]`);

                // Function to determine color based on value
                function getColorClass(value) {
                    return value < 0 ? 'color-red' : 'color-green';
                }
                var sector = item.sector;  
                var selectedSector = $("#sector").val();                
               formattedVolume = volume.toLocaleString();
                    var dollarVolume = ((volume || 0) * (lastTrade || 0)).toFixed(2); 
                    var formattedDollarVolume = '$' + Number(dollarVolume).toLocaleString();    
                //$("#lastUpdated").html(lastUpdated+' '+timeWithoutMilliseconds);

                //console.log("selectedSector = ",+selectedSector);
                if(sector==selectedSector){
                    //console.log("selectedSector=",+selectedSector);
                    //console.log(selectedSector);
                    if (lastTrade !== 0) {
                        if (!row) {
                            row = document.createElement("tr");
                            row.setAttribute("data-symbol", item.Identifier);
                            row.innerHTML = `                                
                                <td class="symbol">
                                    <a href="/stock-detail/NASDAQ/${item.Identifier}/overview" target="_blank">${item.Identifier}</a>
                                </td>
                                <td class="company">
                                    <a href="/stock-detail/NASDAQ/${item.Identifier}/overview" target="_blank">${companyName}</a>
                                </td> 
                                <td class="sector">${sector}</td>
                                <td class="bid">${bid}</td>
                                <td class="ask">${ask}</td>
                                <td class="lastTrade">$${lastTrade}</td>
                                <td class="netChange ${getColorClass(netChange)}">$${netChange}</td>
                                <td class="perChange ${getColorClass(perChange)}">${perChange}</td>
                                <td class="volume">${formattedVolume}</td>
                                <td class="dollarVolume">${formattedDollarVolume}</td>
                            `;
                            document.querySelector("table tbody").appendChild(row);
                        } else { 
                            row.querySelector(".symbol").innerHTML = `<a href="/stock-detail/NASDAQ/${item.Identifier}/overview" target="_blank">${item.Identifier}</a>`;
                            row.querySelector(".company").innerHTML = `<a href="/stock-detail/NASDAQ/${item.Identifier}/overview" target="_blank">${companyName}</a>`;
                            row.querySelector(".sector").textContent = sector;
                            row.querySelector(".bid").textContent = bid;
                            row.querySelector(".ask").textContent = ask;
                            row.querySelector(".lastTrade").textContent = `$${lastTrade}`; 
                            row.querySelector(".netChange").textContent = '$'+netChange;
                            row.querySelector(".netChange").className = `netChange ${getColorClass(netChange)}`;
                            row.querySelector(".perChange").textContent = perChange;
                            row.querySelector(".perChange").className = `perChange ${getColorClass(perChange)}`;
                            row.querySelector(".volume").textContent = formattedVolume;
                            row.querySelector(".dollarVolume").textContent = formattedDollarVolume;
                        }
                    }
                } 
            });
            $("#loader").css('display','none');
        }
   } 

</script>

  
<script>

// Select the button inside the dropdown menu
const filterButton = document.querySelector('.filterButton');

// Add a click event listener to toggle the class
filterButton.addEventListener('click', function() {
    const icon = filterButton.querySelector('i');  // Select the <i> tag inside the button
    
    // Toggle the class between 'fa-filter' and 'fa-close'
    if (icon.classList.contains('fa-filter')) {
        icon.classList.remove('fa-filter');
        icon.classList.add('fa-close');
    } else {
        icon.classList.remove('fa-close');
        icon.classList.add('fa-filter');
    }
});

</script>


@endsection
