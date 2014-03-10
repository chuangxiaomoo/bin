mydate=( `LIMIT=90 SELECT 3` )

for i in ${mydate[@]}; do
    echo -n "$i "
    echo "
    SELECT count(code) FROM day WHERE date = '${i}';
    " | mysql kts -N

    # 2013-12-27 1447
done
