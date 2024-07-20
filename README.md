<h1 align="center">
  <br>
  <a href="Whisk, Whisk!"><img src="https://github.com/Samah-K/Kodeco-Capstone/blob/main/Capstone-Cookbook/Capstone-Cookbook/Assets.xcassets/AppIcon.appiconset/AppIcon.png" alt="Markdownify" width="200"></a>
  <br>
  Whisk, Whisk
  <br>  
</h1>
  Whisk, Whisk! is an app that lets users explore new recipes and write down their own recipes
  


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

---
# A Walkthrough of the App
## Starting the App

- The App starts with a launch screen that shows someone cooking with their cookbook.
- Then, the onboarding screen appears.
    - It is a tab view that has `.page`  as a style `.tabViewStyle(.page)`
    - The tab view includes 4 tabs; each tab has an image and some text
    - When swiping between tabs, the image will be animated `scaleEffect`
    - The screen has a button “Let’s start cooking”.
    - The user has to tap the button to proceed to the next screen
    - This screen appears only once when the App is first launched

## The App has two tabs

1. Cookbook `MyRecipesView.swift`
    - The added recipes will appear here
    - The Tab’s Empty State `EmptyCookBook.swift`
        - When no recipe is added to the cookbook, the App will show:
            - an image
            - a message tells the users that their cookbook is empty
            - two buttons to direct the user on how to use the App
                - **Add a New Recipe** button: this button opens the “Add New Recipe” screen
                - **Explore and get inspired** button: this selects the second tab
    - **Tab’s content**
        - When recipes are added to the cookbook, they will appear in a list
            - A `LazyVGrid` was used. `RecipeGridView.swift`
            - The `LazyVGrid` has one column when the device is in portrait mode and two columns when in landscape
        - Each item in the list has:
            - an image,
            - a title,
            - The total cooking time (which includes the preparation time + cooking time)
            - A heart icon to remove the recipe from the cookbook `RecipeItemView.swift`
                - A confirmation message will be presented to the user to confirm the removal of the recipe
            - When a recipe is tapped, a view will appear showing the recipe’s details
    - **The tab’s toolbar**
        - The tab has **one** button on the **top-right corner**
        - This button will direct the user to the **“Add new recipe”** screen
2. Explore `ExploreRecipesView.swift`
    - Users can search for recipes and add some to their cookbook
    - The Tab’s Empty State `SearchStateView.swift`
        - When no search has been made yet, the App will show
            - An icon + a message that directs the user to enter a recipe name to search for recipes online
    - Tab’s Content
        - When recipes are found, they will appear in a list
            - This tab also uses the same list, `RecipeGridView.swift` (same as the cookbook tab)
            - When the user reaches the end of the list, the App will fetch new data (for the same search)
        - The list items are the same as the “Cookbook” list; the only difference is that the “heart” icon is not selected.
            - User can tap the heart icon to add the recipe to their cookbook without the need to look into the recipe’s details
            - When a recipe is tapped, a view will appear showing the recipe’s details
        - The user can click the [x] button next to the search bar to clear the search (go back to the initial state)
        - The App shows a message that tells the user the search state, and what to do in case there is a problem with the search:
            - No results:
                - “No recipes were found” → “Check the spelling or try a new result.”
            - Searching:
                - “Looking for recipes…”
            - Start the search:
                - “What Are You Craving”
    - The tab’s toolbar
        - The tab has no toolbar

## The Recipe’s Details View `RecipeDetailsView.swift`

- When the user taps any recipe (`RecipeItemView.swift`), in any of the lists, the App will direct them to a new view. This view shows
    - The recipe’s image
        - If no image was provided, the App will show a placeholder image
    - The recipe’s name
    - The recipe’s description
        - The App only shows four lines of the description
        - When the user taps the description, a popup will appear showing the full, detailed recipe description. The popup appears with a fade-in animation.
        - When the user taps outside the popup, it will disappear.
    - The preparation time + the cooking times
    - A button to show the instructions list.
        - The instruction list is a new view that shows:
            - A list of the instructions, where the step number precedes each instruction
            - A video icon in the toolbar.
                - When the user taps this icon, a video of the recipe will start playing
                - When the user taps the icon again, the video will disappear.
    - A button to show the ingredient list (which includes the measurement too)
        - The ingredient list is just a list that shows the ingredients of the recipe, divided into sections.
- The view’s toolbar
    - This view has different buttons according to the selected tabs.
        - If the selected tab is “Explore,” → the button is a heart shape icon to add/remove the recipe to/from the cookbook
        - If the selected tab is “Cookbook,” → the button is a text “Edit” to edit the recipe
    

## Add/Edit recipe view `AddRecipeView.swift`

- The same view is used to add or edit recipes. The only difference is that when:
    - editing a recipe, the recipe’s info will be loaded into the view,
    - adding a new recipe, no data is loaded into the view
- Users can add/edit:
    - The image.
        - There are two types of images that the App can handle
            1. Async Images → If the image has a URL `RecipeAsyncImage.swift`
                - This view handles the 3 phases of an async image: empty, failure, and success.
                - A placeholder will be shown for the first two states
                - The App caches async images
            2. Custom images
                - The user can pick the image using the ImagePicker
                - image is saved to the document’s folder
            3. When no image is found, no URL or custom image, the App will show a placeholder image.
    - Recipe’s name
    - Recipe’s description
    - Add/Edit Ingredient Button [see below]
    - Add/Edit instructions [see below]
    - Set the preparation time and the cooking time using a custom view “TimePicker.swift”
    - This view shows two pickers side by side, one for the hours and one for the minutes.
    - Add video URL
      - YouTube videos which are supported using `SFSafariViewController`
      - A regular video `RecipeVideoPlayer.swift` (using `AVPlayer(url:)`
    - The number of people
        
 
## Add/Edit Ingredient Button
- When tapping this button, a sheet will appear to allow the user to add/edit ingredients
- The ingredients are divided into sections, for example, pie dough, “filling”, “topping”, etc (This is how the API organizes the ingredient) `AddIngredientSectionsView.swift`
- Users can add new sections, edit the name of the already existing recipes, and tap a section to start adding/editing ingredients `AddIngredientListView.swift`
- When selecting a section `AddIngredientListView.swift`
    - The user can **edit an ingredient** by **clicking on the ingredient’s name**
    - The user can **add a new ingredient** by clicking the [+ ingredient] button in the toolbar
- When adding/editing ingredients, a view will appear allowing the user to `AddIngredientAndMeasurementView.swift`
    - **Add/Edit** the **ingredient name;** the user can also provide singular and plural names, which the App will use to display the ingredient description
    - **Add/Edit** the **quantity** of the ingredient
    - **Specify** a **unit** to measure the ingredient. Units can be:
        - Metric or Imperial:
            - Users can enter one value and use the calculation button to calculate the other. They only have to provide both units
        - NONE, this can be a teaspoon, tablespoon, slice, etc., or *none* for things like eggs.

## Add/Edit instructions
- When tapping this button, a sheet will appear to allow the user to add/edit instructions `AddInstructionsListView.swift`
- User can:
  - **Add** new instruction `AddInstructionsListView.swift`
  - click on an instruction to **edit** it `AddInstructionsListView.swift`
  - reorder the instructions by moving them in the list
  

## The App shows alerts to:
- Alert the users that an error has occurred
- Confirm that the user wants to remove a recipe, an ingredient’s section, an ingredient, an instruction
- Confirm that the user wants to discard the changes (move back)
