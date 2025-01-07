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
                                <td class="symbol">
                                    <a href="/stock-detail/NASDAQ/${symbol}/overview" target="_blank">${symbol}</a>
                                </td>
                                <td class="company">
                                    <a href="/stock-detail/NASDAQ/${symbol}/overview" target="_blank">${companyName}</a>
                                </td> 
                                <td class="sector">${sector}</td>
                                <td class="lastTrade">$${lastTrade}</td>
                                <td class="netChange ${getColorClass(netChange)}">$${netChange}</td>
                                <td class="perChange ${getColorClass(perChange)}">${perChange}</td>
                                <td class="volume">${formattedVolume}</td> 
                                <td class="dollarVolume">${formattedDollarVolume}</td>
                            `;
                            document.querySelector("table tbody").appendChild(row);
                        } else { 
                            row.querySelector(".symbol").innerHTML = `<a href="/stock-detail/NASDAQ/${symbol}/overview" target="_blank">${symbol}</a>`;
                            row.querySelector(".company").innerHTML = `<a href="/stock-detail/NASDAQ/${symbol}/overview" target="_blank">${companyName}</a>`;                            
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
