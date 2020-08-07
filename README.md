# add_image_size_tool

## usage

### with Docker

`img_src_prefix` : if `<img src="//example.com/resource/img/example.gif">`, then `https:`

```shell script
chmod +x main.sh
./main.sh [target_html_file] [img_src_prefix]
```

### without Docker

```shell script
bundle install
bundle exec ruby main.rb [target_html_file] [img_src_prefix]
```


