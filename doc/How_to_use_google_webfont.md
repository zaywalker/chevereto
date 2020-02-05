[**한국어 설명서는 여기로**](https://github.com/zaywalker/chevereto/blob/master/doc/구글_웹폰트_사용하기.md)
--------
You can take a look at Google web fonts [here](https://fonts.google.com/)

In order to change your Chevereto font, go to **Custom CSS code** @ **Dashboard > Settings > Theme** and enter some codes.

>If you want to use Nanum Gothic (https://fonts.google.com/specimen/Nanum+Gothic), the code will be like below.

>Note that if the font name has space, you should wrap them in single quotes.

```css
@import url('https://fonts.googleapis.com/css?family=Nanum+Gothic:400,700,800');
html, body {
    font-family: 'Nanum Gothic', Helvetica, Arial, sans-serif;
    font-size: 120%
}
```

You can get more info [here](https://www.w3schools.com/css/css_font.asp)
