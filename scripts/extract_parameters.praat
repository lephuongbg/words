# This script is distributed under the GNU General Public License.
# Copyright 2015 Le Hoang Phuong
# Written for TRVN Project
#
form Analyze pitch maxima from labeled segments in files
    sentence Sound_directory /home/herop/projects/asr/words/trvn/wav/
    sentence Sound_file_extension .wav
    comment Full path of the resulting text file:
    text resultfile /home/herop/projects/asr/words/trvn/result.csv
    
    comment Pitch analysis parameters
    positive Time_step 0.01
    positive Minimum_pitch_(Hz) 75
    positive Maximum_pitch_(Hz) 300
    
    comment Formant analysis parameters
    positive Nr_formants 3
    positive Maximum_(Hz) 3500
endform

Create Strings as file list... "list" 'Sound_directory$'*'Sound_file_extension$'

# Check if the result file exists:
if fileReadable (resultfile$)
    pause The result file 'resultfile$' already exists! Do you want to overwrite it?
    filedelete 'resultfile$'
endif

titleline$ = "Filename"
# Pitch
titleline$ = titleline$ + ",F0_min,F0_max,F0_mean,F0_median,F0_std"
# Formants and amplitude
titleline$ = titleline$ + ",F1_min,F1_max,F1_mean,F1_median,F1_std,F1_bw"
titleline$ = titleline$ + ",F2_min,F2_max,F2_mean,F2_median,F2_std,F2_bw"
titleline$ = titleline$ + ",F3_min,F3_max,F3_mean,F3_median,F3_std,F3_bw"
titleline$ = titleline$ + ",SPL_min,SPL_max,SPL_mean,SPL_median,SPL_std"
titleline$ = titleline$ + "'newline$'"
fileappend "'resultfile$'" 'titleline$'

numberOfFiles = Get number of strings
for ifile to 'numberOfFiles'
    #echo 'ifile' of 'numberOfFiles' 'newline$'
    select Strings list
    filename$ = Get string... 'ifile'
    
    # A sound file is opened from the listing:
    Read from file... 'sound_directory$''filename$'
    soundname$ = selected$ ("Sound", 1)

    # Starting from here, you can add everything that should be
    # repeated for every sound file that was opened:
    noprogress To Pitch... time_step minimum_pitch maximum_pitch
    f0min = Get minimum... 0 0 Hertz None
    f0max = Get maximum... 0 0 Hertz None
    f0mean = Get mean... 0 0 Hertz
    f0median = Get quantile... 0 0 0.5 Hertz
    f0std = Get standard deviation... 0 0 Hertz
    Remove
    
    # Formants
    select Sound 'soundname$'
    noprogress To Formant (burg)... 0 nr_formants maximum 0.025 50
    f1min = Get minimum... 1 0 0 Hertz Parabolic
    f1max = Get maximum... 1 0 0 Hertz Parabolic
    f1mean = Get mean... 1 0 0 Hertz
    f1median = Get quantile... 1 0 0 Hertz 0.5
    f1std = Get standard deviation... 1 0 0 Hertz
    f1bw = Get quantile of bandwidth... 1 0 0 Hertz 0.5
    
    f2min = Get minimum... 2 0 0 Hertz Parabolic
    f2max = Get maximum... 2 0 0 Hertz Parabolic
    f2mean = Get mean... 2 0 0 Hertz
    f2median = Get quantile... 2 0 0 Hertz 0.5
    f2std = Get standard deviation... 2 0 0 Hertz
    f2bw = Get quantile of bandwidth... 2 0 0 Hertz 0.5
    
    f3min = Get minimum... 3 0 0 Hertz Parabolic
    f3max = Get maximum... 3 0 0 Hertz Parabolic
    f3mean = Get mean... 3 0 0 Hertz
    f3median = Get quantile... 3 0 0 Hertz 0.5
    f3std = Get standard deviation... 3 0 0 Hertz
    f3bw = Get quantile of bandwidth... 3 0 0 Hertz 0.5
    
    bandwidth_at_timef1 = Get bandwidth at time... 1 0.5 Hertz Linear
    bandwidth_at_timef2 = Get bandwidth at time... 2 0.5 Hertz Linear
    bandwidth_at_timef3 = Get bandwidth at time... 3 0.5 Hertz Linear
    Remove

    #Make intensity calcs
    select Sound 'soundname$'
    noprogress To Intensity... 70 0 yes
    splmin = Get minimum... 0 0 Parabolic
    splmax = Get maximum... 0 0 Parabolic
    splmean = Get mean... 0 0 energy
    splmedian = Get quantile... 0 0 0.5
    splstd = Get standard deviation... 0 0
    Remove

    # Save result to text file:
    resultline$ = "'soundname$'"
    resultline$ = resultline$ + ",'f0min:2','f0max:2','f0mean:2','f0median:2','f0std:2'"
    resultline$ = resultline$ + ",'f1min:2','f1max:2','f1mean:2','f1median:2','f1std:2','f1bw:2'"
    resultline$ = resultline$ + ",'f2min:2','f2max:2','f2mean:2','f2median:2','f2std:2','f2bw:2'"
    resultline$ = resultline$ + ",'f3min:2','f3max:2','f3mean:2','f3median:2','f3std:2','f3bw:2'"
    resultline$ = resultline$ + ",'splmin:2','splmax:2','splmean:2','splmedian:2','splstd:2'"
    resultline$ = resultline$ + "'newline$'"
    fileappend "'resultfile$'" 'resultline$'
    
    # Remove the temporary objects from the object list
    select Sound 'soundname$'
    Remove
    # and go on with the next sound file!
endfor
select Strings list
Remove
