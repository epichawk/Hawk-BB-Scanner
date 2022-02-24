#!/bin/bash

target_list="https://raw.githubusercontent.com/arkadiyt/bounty-targets-data/master/data/domains.txt"
test_list="domains-test.txt"
target_list_main="domains.txt"
target_list_subs="subdomains.txt"
target_list_httpx="httpdomains.txt"

function new_targets {
    echo "Removing Old Targte List.."
    for oldList in $( rm $target_list_main);do
        $oldList
    done
    echo "Download New Target List.."
    wget $target_list
    clear

    for domains in $(wc -l $target_list_main );do
        echo $domains
        

    done
}



function scan_targets_subs {
    echo ""    
    echo "Starting new scan..."
    
    for sub_targets in $(subfinder -timeout 1 -t 500 -dL $target_list_main > $target_list_subs);do
        echo $sub_targets

    done
 
    for line in $(wc -l $target_list_subs);do
            echo $line
    done
}


function add_targets_http {
    echo ""
    echo "HTTP-HTTPS is being added now.."

    for httpx_targets in $(httpx -l $target_list_subs > $target_list_httpx);do
        echo $httpx_targets
    done

    for line in $(wc -l $target_list_httpx);do
        echo $line
    done

}

function nuclei_critical_scan {
    echo ""
    for update_nuclei in $(nuclei -ut);do
        echo "Updating Nuclei.."
        
    done

    echo ""
    echo "Scanning Targets Now..."
    for main_scan in $(nuclei -l $target_list_httpx -t ~/nuclei-templates/ -c 800 -stats -si 90 -timeout 2 -severity critical -o FoundVulns.txt);do
        echo $main_scan

    done
}

while true ;do
    new_targets
    scan_targets_subs
    add_targets_http
    nuclei_critical_scan
exit

done
