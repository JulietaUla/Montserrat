# The Montserrat Font Project
To use this font as a webfont, ```Montserrat.css``` is included.

## How to use
### 1. @import
You can import the file into your stylesheet as follows:
```css
@import url("static/fonts/Montserrat/fonts/webfonts/Montserrat.css");
```

**NOTE:** The directory where the stylesheet is placed.

Then we can use it to style elements:
```css
body {
  font-family: 'Montserrat', sans-serif;
  font-weight: 400;
}
```

### 2. \<link>ing a stylesheet
Similarly, you could link to the same asset as you would any other CSS filter, in the \<head> of the HTML document rather than in the CSS:
```html
<link rel="stylesheet" type="text/css" href="static/fonts/Montserrat/fonts/webfonts/Montserrat.css">
```

**NOTE:** The directory where the stylesheet is placed.

Then we can use it to style elements:
```css
body {
  font-family: 'Montserrat', sans-serif;
  font-weight: 400;
}
```