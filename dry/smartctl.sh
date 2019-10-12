sudo smartctl /dev/nvme0 -x | tee  ~/workspace/data/nvme-stats/$(date --iso-8601=s)-0.txt
sudo smartctl /dev/nvme1 -x | tee  ~/workspace/data/nvme-stats/$(date --iso-8601=s)-1.txt