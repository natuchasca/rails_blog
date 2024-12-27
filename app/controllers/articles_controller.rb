class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy publish unpublish]
  before_action :authenticate_user!, only: %i[ edit update destroy publish unpublish]
  before_action :authorize_article, only: %i[ edit update destroy publish unpublish]

  def index
    @articles = Article.order(created_at: :desc)
    #@articles = policy_scope(Article).order(created_at: :desc)
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
    authorize Article
  end

  def create
    authorize Article
    @article = Article.new(article_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy!

    respond_to do |format|
      format.html { redirect_to articles_path, status: :see_other, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def publish
    authorize @article  # Autoriza la acción 'publish'

    if @article.update(publication_state: :published)
      redirect_to @article, notice: "Artículo publicado con éxito."
    else
      redirect_to @article, alert: "No se pudo publicar el artículo."
    end
  end

  def unpublish
    authorize @article  # Autoriza la acción 'unpublish'

    if @article.update(publication_state: :draft)
      redirect_to @article, notice: "Artículo vuelto a borrador."
    else
      redirect_to @article, alert: "No se pudo cambiar el estado del artículo."
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def article_params
    params.expect(article: [ :title, :body ])
  end

  # Authorize the article actions
  def authorize_article
    authorize @article
  end
end
