

route = RouteController()

// Add somthing that is very convention over configuration
route.add("/rails", RailsLikeController())
// Add somthing that is very MVC centric
route.add("/mvc", MVCController())
// Add a lift like controller with pure transforms
route.add("/lift", MyLift())

// Setup a REST like controller
rest = MyRest()
// add a filter that always return json
rest.add("/rest/json", Json())
// add a filter that preforms content negotiation 
rest.add("/rest/content", ContentNegotiation())
// Add the MyRest filter to the route filter
route.add("/rest", rest)

// Add authentication to the entire application
auth = AuthenticationController()
// Only allow access to this route if the someValidationMethod() returns true or some such thing
auth.only("/rest", someValidationMethod)
// Add authentication
route.add("/", auth)

// Serve up the application
serve(route)


class MyRest extends RestController(){

  // Define some routes to match
  self.route.add("/rest", "GET", self.index)

  def index(req) {
    // validate params
    // See Post.py

    // If we have auth enabled, get the authentication filter
    // and ask it for the user we logged in as
    user = req.filter('auth').getUser().else("no-user")

    // get params
    req.params.get("blah").else("default")
    return Ok("<h2>blah</h2>")
  }
}


class MyLift extends LiftLikeController {
  
  // Define some routes to match the page
  self.route.add("/lift", "/public/index.html")

  // Modify the session and return the modified session
  def Session index(Session session) {
    // Preform transforms on the session dom
    session.dom.select("#time *")
  }
}


