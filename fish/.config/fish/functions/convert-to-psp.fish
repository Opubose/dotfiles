function convert-to-psp
    set input $argv[1]
    set base (basename $input .mp4)
    set output "$base"_psp.mp4

    ffmpeg -i $input \
        -c:v libx264 -profile:v main -level 3.0 -preset slow -crf 18 \
        -c:a aac -b:a 128k -ac 2 \
        -s 480x272 \
        -movflags +faststart \
        $output
end

