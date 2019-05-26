# Team Bagg Crushers
This project is our teams submission to OpenHack Gothenburg 2019. 

#### Team Members
- Henrik Lagergren
- Carl Östling
- Aron Sjöberg
- Viktor Franzén

## The Case
We choose the Sida case. Below comes an brief description of the problem copied from
the challange description:

*"Sida has a need for an illustrated tool to get a view of how the flow of Sida ́s ODA (Official
 Development Assitance) matches corruption risks in countries and, in these, sectors that
 have high corruption risks."*

## Our solution
Our teams solution is to create an app where we display the given aid 
and corruption index in an nice and easy to understand way. We also display
 which of Sidas current investments contains the most risks by dividing 
 the given aid with the countrys corruption index. The higher the result of this
 is the higher the risk of the money being used wrongly.
 
 We also have a more detailed view for each country where we display in what
 sectors the investments are made. In the beggining of the project 
 we wanted to do the risk calculation by sector aswell but we could not find
 any data on the corruption index by sector unfortunately but that is definitely 
 something that would be a great feature in the app. 

## Services used
#### Flag API
To display flags for each country we have used an online API called Countrylags.
It can be found on https://www.countryflags.io/.

Copyright (c) 2017 Go Squared Ltd. http://www.gosquared.com/

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#### Dart plugins
We have used some dart plugins. To see which we direct you to the pubspec.yml file
found in the flutter directory. Under dependencies it is possible to see the plugins used.'

## Programming languages used
For the app we have used the Dart programming language with the Flutter 
framework.

To combine the data of the corruption index and the given aid we have used Python
with numpy and pandas.


## License
The MIT License (MIT)

Copyright (c) 2019 Henrik Lagergren, Viktor Franzén, Carl Östling, Aron Sjöberg.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
