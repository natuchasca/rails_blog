class ArticlePolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def new?
    user.present?
  end

  def create?
    user.present?
  end

  def show?
    true
  end

  def edit?
    user.present? && user_owns_article?
  end

  def update?
    user.present? && user_owns_article?
  end

  def destroy?
    user.present? && user_owns_article?
  end

  def user_owns_article?
    record.user_id == user.id
  end

  def publish?
    user.present? && user_owns_article?
  end

  def unpublish?
    user.present? && user_owns_article?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end

    def resolve
      if user.present?
        # Mostrar artículos que el usuario creó o que están publicados
        scope.where(user_id: user.id).or(scope.where(publication_state: "published"))
      else
        # Mostrar solo los artículos publicados para usuarios no autenticados
        scope.where(publication_state: "published")
      end
    end

  end
end
