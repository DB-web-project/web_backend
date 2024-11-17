# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Admin
Admin.create(name: '杜启嵘', email: 'dqr@buaa.edu.cn', password: 'dqr123456')
User.create(name: '石通', email: 'st@qq.com', password: 'st123456')
Business.create(name: '高悠然', email: 'gyq@buaa.edu.cn', password: 'gyr123456')
