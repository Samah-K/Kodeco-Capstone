<h1 align="center">
  <br>
  <a href="Whisk, Whisk!"><img src="https://github.com/Samah-K/Kodeco-Capstone/blob/main/Capstone-Cookbook/Capstone-Cookbook/Assets.xcassets/AppIcon.appiconset/AppIcon.png" alt="Markdownify" width="200"></a>
  <br>
  Whisk, Whisk
  <br>  
</h1>
  Whisk, Whisk! is an app that lets users explore new recipes and write down there own recipes


## Features

- Get Inspired: search for recipes online and add them to the cookbook
- Add new recipes, such as grandma's secret recipe, perhaps?
- Edit recipes: all recipes in the cookbook can be edited.

## Used APIs

The app connects to two APIs

- **An API called "Tasty" to search for recipes** `TastyNetworkService.swift`
    - The main API that the app uses to search for recipes [online](https://tasty.co).
    - The app reads the JSON response and displays the recipes for the user in a list *(a grid view, which has one row in portrait mode and two in landscape mode)*
    - API Limitation: The API allows only 500 requests/month (I already used all the requests 😅, I paid for an extra 10,000 requests)
- **An API called "Spoonacular" to convert between ingredient units** `SpoonacularNetworkService.swift`
    - A famous conversion that the app can do is converting between cups and grams.
      _- Recalling from physics class, one unit is used to measure volume (cups), and the other is used to measure mass (grams), so we need to have the ingredient's density to convert between the two_
    - Spoonacular to the rescue! This amazing API can do the calculation for us. (Imagine having to add all the ingredient's density in the app! Just the idea makes me dizzy 😵‍💫)
    - API Limitation: The API allows 500 requests/month

No third-party frameworks or packages were used in the app.
*The API's keys were submitted*

## Saving Data

- In the app's document:
    1. **MyRecipes.JSON**
       - When the user adds a recipe to the cookbook (either a custom recipe or from Tasty API), it will be added to a file named" `MyRecipes.JSON` in the app's document
       - Also, when the user edits or removes the recipe, the changes will be reflected in the file
    2. **Recipe's Images**
       - When the user changes the recipe's image, the new image is saved to the app's document directory.
       - The image will be named as follows: `Recipe_ID.jpg`
- **@AppStorage**: to show the "onboardingView" only on the first run

## The App uses MVVM

- The project is divided into three main sections
    - **Model**
        - Model and data
        - Structures that are used to calculate measurements
        - Mockup data [to use instead of connecting to the API]
    - **View**
        - Views are extracted into separate views
        - Views that appear in the same view are kept in the file
        - Each view has a preview
    - **ViewModel**
        - It has one `ObservableObject` with 3 `@Published` values. [ `RecipesStore.swift`]
        - A class to read and write `MyRecipes.JSON` [`MyCookbookFileStore.swift`]
        - The two network services classes: `SpoonacularNetworkService.swift` and `TastyNetworkService.swift`

## Testing

- The project has a test plan including both UI and unit tests, which covers about 57% 😵‍💫
- Before running the test, **please make sure to uninstall the app first**, which include
    - The app: Whisk, Whisk!
    - The test runner: CookbookUITests-Runner (If you already had run the test)


## The App includes:

- A custom app icon
- A static launch screen
- An onboarding experience with animation
- A custom display name
- All texts are styled
- **Three SwiftUI Animation**
  - The images that appear in the onboarding view [scale animation]
  - The popup view that shows the recipe's description [fade in/out animation]
      - I had to use `DispatchQueue` for this animation to allow the popup to fade out
  - The image that appears when the cookbook is empty [scale animation]

## Next Step?

- **New Features**
    - The app is still missing some features, some of these features include
    - The ability to log the user's attempt to cook a recipe. Users can add an image, give themselves a score, and write a review/comments
    - Calculate the nutrition for the recipe
    - Scale ingredients according to the number of people
    - Add sections to the cookbook (tags), like breakfast, dinner, snack, etc
    - Show instructions in real-time, one step at a time, and add counters that send notifications to remind the user to turn the oven off for example, (or get the toast out of the toaster 🌚)
- **Fix some bugs**
    - Remove the added images when the recipe is removed or when the user discards the changes made to new recipes
- **Improve Test plan**
    - I kind stopped adding tests when I hit the 50% mark of code coverage

