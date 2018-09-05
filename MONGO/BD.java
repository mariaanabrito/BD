package bd;

import java.sql.*;
import java.util.Date;
import com.mongodb.*;
import java.util.ArrayList;
import java.util.List;


public class BD {
   // JDBC driver name and database URL  
   static final String DB_URL = "jdbc:mysql://localhost/PolkaTerra";

   //  Database credentials
   static final String USER = "root";
   static final String PASS = "yukijudai";
   static Connection conn = null;
   static Statement stmt = null;
   
   
public static void toStrReserva(ResultSet rs){
      //Retrieve by column name
      try{
      int id_reserva  = rs.getInt("id_reserva");
      String lugar = rs.getString("lugar");
      String id_cliente = toStrCliente(rs.getInt("id_cliente"));
      String id_viagem = toStrViagem(rs.getString("id_viagem"));
      Date data = rs.getDate("data");

      //Display values
      System.out.println("id_reserva: " + id_reserva);
      System.out.println("Cliente: ");
      System.out.println(id_cliente);
      System.out.println("Viagem: ");
      System.out.println(id_viagem);
      System.out.println("Data: " + data);
      System.out.println("Lugar: " + lugar + "\n\n");
      }catch(SQLException se){
          //Handle errors for JDBC
          System.out.println(se.getMessage());
          se.printStackTrace();
         }catch(Exception e){
             //Handle errors for Class.forName
             System.out.println(e.getMessage());
             e.printStackTrace();
         }
 }
   
   public static String toStrCliente(int num_cc)
   {
       StringBuilder sql = new StringBuilder();
       sql.append("SELECT * FROM cliente ")
          .append("where num_cc = " + num_cc);
       
       StringBuilder str = new StringBuilder();
       
       try
       {
            stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql.toString());
            rs.next();

            str.append("\tCC: " + num_cc + "\n\t");
            str.append("Email: " + rs.getString("email") + "\n\t");
            str.append("Nome: " + rs.getString("nome") + " ");
            str.append(rs.getString("apelido") + "\t");
       }catch(SQLException se){
       //Handle errors for JDBC
            System.out.println(se.getMessage());
            se.printStackTrace();
       }catch(Exception e){
       //Handle errors for Class.forName
            System.out.println(e.getMessage());
            e.printStackTrace();
       
        }//end try
    return str.toString();
}
 

   public static String toStrViagem(String id_viagem){
       StringBuilder sql = new StringBuilder();
       sql.append("SELECT * FROM viagem ");
       sql.append("where id_viagem = '" + id_viagem + "'");
       StringBuilder str = new StringBuilder();
       try{
       stmt = conn.createStatement();
       ResultSet rs = stmt.executeQuery(sql.toString());
       rs.next();
       
       str.append("\tID: " + id_viagem + "\n\t");
       str.append("PreÃ§o: " + rs.getFloat("preÃ§o") + "\n\t");
       str.append("Origem: " + rs.getString("Origem") + "\n\t");
       str.append("Destino: " + rs.getString("Destino") + "\n\t");
       str.append("Hora: " + rs.getTime("Hora") + "\n\t");
       str.append("Tipo: "+ rs.getString("Tipo") + "\n\t");
       }catch(SQLException se){
       //Handle errors for JDBC
       System.out.println(se.getMessage());
       se.printStackTrace();
       }catch(Exception e){
       //Handle errors for Class.forName
       System.out.println(e.getMessage());
       e.printStackTrace();
       
    }//end try
    return str.toString();
} 
   
public static BasicDBObject toObjectLugar(String n, int cl, String cr, float p)
{
    BasicDBObject obj = new BasicDBObject();
    
    obj.append("número", n)
       .append("classe", cl)
       .append("carruagem", cr)
       .append("preço", p);
    
    return obj;
}

public static void main(String[] args) 
{
   try{
      Class.forName("com.mysql.jdbc.Driver");
      
      System.out.println("Connecting to a selected database...");
      conn = DriverManager.getConnection(DB_URL, USER, PASS);
      System.out.println("Connected database successfully...");
      
      System.out.println("Creating statement...");
      stmt = conn.createStatement();
      
      Mongo mongo = new Mongo("localhost", 27017);
      DB db = mongo.getDB("polkaterra");
      String sql;
      ResultSet rs;
      DBCollection coll = db.getCollection("polkaterra");
      BasicDBObject doc;
     
      String str;
      ResultSet result;
      Statement stm = conn.createStatement();
      sql = "SELECT * FROM Comboio";
      rs = stmt.executeQuery(sql);
      while(rs.next())
      {
          doc = new BasicDBObject();
          int id_comboio = rs.getInt("id_comboio");
          doc.append("comboio", id_comboio);
          str = "SELECT * from Lugar where id_comboio = " + id_comboio;
          result = stm.executeQuery(str);
          List<BasicDBObject> lugares = new ArrayList<>();
          while(result.next())
          {
              String numero = result.getString("número");
              int classe = result.getInt("classe");
              String carruagem = result.getString("carruagem");
              float preco = result.getFloat("preço");
              lugares.add(toObjectLugar(numero, classe, carruagem, preco));
          }
          doc.append("lugares", lugares);
          coll.insert(doc);
      }
      stmt = conn.createStatement();
      sql = "Select * from Cliente";
      rs = stmt.executeQuery(sql);
      while(rs.next())
      {
          doc = new BasicDBObject();
          int numcc = rs.getInt("num_cc");
          String email = rs.getString("email");
          String nome = rs.getString("nome");
          String apelido = rs.getString("apelido");
          doc.append("CC", numcc)
             .append("nome", nome + " " + apelido)
             .append("email", email);
          str = "SELECT id_reserva from Reserva where id_cliente = " + numcc;
          result = stm.executeQuery(str);
          List<BasicDBObject> reservas = new ArrayList<>();
          while(result.next())
          {
              reservas.add(new BasicDBObject("número_reserva", result.getInt("id_reserva")));
          }
          doc.append("reservas", reservas);
          coll.insert(doc);
      }
      
      
   }
   catch(SQLException se)
   {
      System.out.println(se.getMessage());
      se.printStackTrace();
   }
   catch(Exception e)
   {
      System.out.println(e.getMessage());
      e.printStackTrace();
   }
   finally
   {
      try{
         if(stmt!=null)
            conn.close();
      }catch(SQLException se){
      }
      try{
         if(conn!=null)
            conn.close();
      }catch(SQLException se){
         se.printStackTrace();
      }
   }
   System.out.println("Goodbye!");
}
}

