#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include <time.h>

#define BAT_PATH "/sys/class/power_supply/BAT0/capacity"
#define STAT_PATH "/sys/class/power_supply/BAT0/status"
#define THRESHOLD 25
#define BATTERY_FULL 90
#define CHECK_INTERVAL 600
#define NOTIF_COOLDOWN 600

typedef struct {
    int capacity;
    bool charging;
} BatteryState;

static bool read_battery_state(BatteryState *state) {
    FILE *f = fopen(BAT_PATH, "r");
    if (!f) {
        perror("Failed to open battery capacity");
        return false;
    }
    
    if (fscanf(f, "%d", &state->capacity) != 1) {
        fclose(f);
        return false;
    }
    fclose(f);
    
    f = fopen(STAT_PATH, "r");
    if (!f) {
        perror("Failed to open battery status");
        return false;
    }
    
    char status[16];
    if (fscanf(f, "%15s", status) != 1) {
        fclose(f);
        return false;
    }
    fclose(f);
    
    state->charging = (strcmp(status, "Charging") == 0);
    return true;
}

static void notify(const char *urgency, const char *title, const char *msg) {
    char cmd[256];
    snprintf(cmd, sizeof(cmd), 
             "notify-send -u '%s' '%s' '%s' 2>/dev/null", 
             urgency, title, msg);
    system(cmd);
}

int main(void) {
    BatteryState state;
    time_t last_low_notif = 0;
    time_t last_full_notif = 0;
    time_t now;
    
    while (1) {
        if (!read_battery_state(&state)) {
            sleep(CHECK_INTERVAL);
            continue;
        }
        
        now = time(NULL);
        
        if (state.capacity <= THRESHOLD && !state.charging) {
            if (now - last_low_notif >= NOTIF_COOLDOWN) {
                char msg[128];
                snprintf(msg, sizeof(msg), "Battery is below %d%%.", state.capacity);
                notify("critical", "Battery Low ⚠️", msg);
                last_low_notif = now;
            }
            sleep(CHECK_INTERVAL);
        } 
        else if (state.capacity >= BATTERY_FULL && state.charging) {
            if (now - last_full_notif >= NOTIF_COOLDOWN) {
                notify("normal", "Battery Full!", 
                       "Battery is above 90%.");
                last_full_notif = now;
            }
            sleep(CHECK_INTERVAL);
        } 
        else {
            sleep(CHECK_INTERVAL);
        }
    }
    
    return 0;
}
