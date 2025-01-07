function processBatch() {

const loader = document.getElementById("loader");
if (loader) {
    loader.classList.remove("hidden"); // Remove the hidden class to show the loader
}

const fetchDataOffLineData = async () => {
    console.log("fetchDataOffLineData");
    try {
        const response = await fetch('https://dev.stocks.news:8080/getScreener?sector=Basic Materials'); 
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

for (let port = 8021; port <= 8036; port++) {
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
                } else {
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
                                <td class="time">${timeWithoutMilliseconds}</td>
                                <td class="symbol">
                                    <a href="/stock-scanner/details/${item.Identifier}" target="_blank">${item.Identifier}</a>
                                </td>
                                <td class="company">${companyName}</td>
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
                            row.querySelector(".time").textContent = timeWithoutMilliseconds;
                            row.querySelector(".symbol").innerHTML = `<a href="/stock-scanner/details/${item.Identifier}" target="_blank">${item.Identifier}</a>`;
                            row.querySelector(".company").textContent = companyName;
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
                                   <td class="time">${timeWithoutMilliseconds}</td>
                                   <td class="symbol">
                                       <a href="/stock-scanner/details/${item.Identifier}" target="_blank">${item.Identifier}</a>
                                   </td>
                                   <td class="company">${item.name}</td>
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
                               row.querySelector(".time").textContent = timeWithoutMilliseconds;
                               row.querySelector(".symbol").innerHTML = `<a href="/stock-scanner/details/${item.Identifier}" target="_blank">${item.Identifier}</a>`;
                               row.querySelector(".company").textContent = item.name;
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