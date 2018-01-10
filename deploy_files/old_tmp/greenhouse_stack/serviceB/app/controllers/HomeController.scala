package controllers

import javax.inject._
import play.api._
import play.api.libs.json.Json
import play.api.mvc._
import models.HealthResponse

/**
 * This controller creates an `Action` to handle HTTP requests to the
 * application's home page.
 */
@Singleton
class HomeController @Inject()(cc: ControllerComponents) extends AbstractController(cc) {

  /**
   * Create an Action to render an HTML page.
   *
   * The configuration in the `routes` file means that this method
   * will be called when the application receives a `GET` request with
   * a path of `/`.
   */
  def index() = Action { implicit request: Request[AnyContent] =>
    Ok(views.html.index())
  }

    /**
    * This should have its own controller, but just let's keep it simple
    */
  def goodBye(userName: String): Action[AnyContent] = Action { implicit request: Request[AnyContent] =>
    Ok(s"Goodbye $userName")
  }

  def health(): Action[AnyContent] = Action { implicit request: Request[AnyContent] =>
    {
      val healthValue = HealthResponse(200,"Service B is healthy");

      Ok(Json.toJson(healthValue))
    }
  }
}
