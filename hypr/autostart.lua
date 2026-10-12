-- goat: open the saved app layout across both monitors at login.
-- With no argument the script picks the off-work layout on weekends and on
-- weekdays before 6 AM or from 7 PM, and the work layout otherwise.
o.exec_on_start(os.getenv("HOME") .. "/.config/hypr/scripts/startup-layout.sh")
