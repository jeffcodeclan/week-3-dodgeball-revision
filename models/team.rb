require( 'pg')
require_relative('../db/sql_runner')

class Team
    attr_reader(:id, :team_name, :location)
    def initialize(options)
        @id = options['id'].to_i
        @team_name = options['team_name']
        @location = options['location']
    end

    def save()
        sql = "INSERT INTO teams ( team_name,  location )
              VALUES ( '#{ @team_name }', '#{ @location }' )
              RETURNING *;"
        return Team.map_item( sql )
    end

    def update()
        sql = "UPDATE teams 
                SET team_name = '#{ @team_name }', location = '#{ @location }', 
                WHERE id = #{ @id };"
        return Team.map_items( sql )
    end

    def delete()
        sql = "DELETE FROM teams WHERE id = #{ @id };"
        SqlRunner.run( sql )
    end

    def self.delete_all()
        sql = "DELETE FROM teams;"
        SqlRunner.run( sql )
    end

    def self.map_items( sql )
        teams = SqlRunner.run( sql )
        result = teams.map { |team| Team.new( team ) }
        return result
    end

    def self.map_item( sql )
        result = Team.map_items( sql )
        return result.first
    end
end  