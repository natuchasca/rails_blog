class AddUserToArticle < ActiveRecord::Migration[8.0]
  def up
    # Agregar la columna con valores nulos permitidos
    add_reference :articles, :user, null: true, foreign_key: true

    # Asegurarse de que todos los registros existentes tengan un user_id
    reversible do |dir|
      dir.up do
        # Crear usuario predeterminado
        default_user = User.find_or_create_by(email: "unknown@example.com") do |user|
          user.password = SecureRandom.hex(8)
        end

        # Asociar comentarios existentes al usuario predeterminado
        Article.where(user_id: nil).update_all(user_id: default_user.id)
      end
    end

    # Aplicar la restricción NOT NULL después de que los datos hayan sido actualizados
    change_column_null :articles, :user_id, false
  end

  def down
    # Eliminar la referencia
    remove_reference :articles, :user
  end
end
