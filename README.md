# BitpandaApp

## Example App

### Features

• A scrollable list with the name and symbol of the cryptocurrency 

• On click it shows the price change in the last 7 days and the last 1 day and also the current price against Euro

• It has a **Search Controller** to filter the results based on the name or symbol

• It has an **Indicator View** to show the progress

• It shows an **alert** when data cannot be fetched

• Although including images is a great idea, but unfortunately the mentioned API does not provide any image url 
for the cryptocurrencies. There are however other APIs like “https://min-api.cryptocompare.com/”, which provides image urls along with other data.
To avoid calling another API, for this assignment, I chose not to include an image.

### Architecture

• MVVM was used

• Closures were used to bind the view model (referred as interactor) in this project to the view controller

• Protocols and extensions were used to segregate Presentation Logic from Business Logic

### Unit Test

• An example test case was written to test the binding between view controller and view model.

### UI

• The UI followed the Auto Layout format and appropriate constraints were given to make it suitable for all the iOS devices

### Libraries

[Alamofire](https://github.com/Alamofire/Alamofire)

**Screenshots are uploaded to the repository**


**Apurva Kochar**
