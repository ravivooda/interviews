#  Apple Pay Security Team - Interview Project - Movie Searcher

## Goal
To allow users to search for a movie title, and show results

## Use Cases

### Happy path
Allow users to type text into search bar, make API call with the text, request ResultsPresenter to present the results

#### Delay search API call by 1 sec
This is designed to avoid calls for every letter input. API calls are data, resource intensive, so optimizing for that. It also gives the user time to type in the movie name they are interested in before actually making a call.  

### Errors
Show error when there is network error

## High Level Architecture

### Search Component
Responsible for buidling and wiring up all search related components

### Search Interactor
Responsible for the business logic of the search functionality 

### Search View Controller, Search Table View ...
UI components, responsible for rendering the search results; Seperates UI from Business Logic 

### Search Service 
Abstracts the API request mechanism from Interactor
