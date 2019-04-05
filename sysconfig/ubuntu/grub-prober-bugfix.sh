#!/bin/bash

echo "[not implemented yet]"
exit 1

## TODO:
## -- 30_os-0-pre-prober

#!/bin/sh
set -e

# Save the $timeout and $timeout_style values set by /etc/grub.d/00_header
# before /etc/grub.d/30_os-prober messes them up.

cat <<EOF
set timeout_bak=\${timeout}
set timeout_style_bak=\${timeout_style}
EOF

## -- 30_os-z-post-prober
#!/bin/sh
set -e

# Reset $timeout and $timeout_style to their original values
# set by /etc/grub.d/00_header before /etc/grub.d/30_os-prober messed them up.

cat <<EOF
set timeout=\${timeout_bak}
set timeout_style=\${timeout_style_bak}
EOF
