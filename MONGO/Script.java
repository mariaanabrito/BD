package basedados;

import java.sql.*;
import com.mongodb.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


public class Script 
{
   private static final String DB_URL = "jdbc:mysql://localhost/PolkaTerra";
   private static final String USER = "root";
   private static final String PASS = "";
   private static Connection conn = null;
   private static PreparedStatement stmt = null;
   
   /*
   Cria um BasicDBObject através dos parâmetros dados.
   */
   public static BasicDBObject toObjectLugar(String n, int cl, String cr, float p)
   {
       BasicDBObject obj = new BasicDBObject();

       obj.append("número", n)
          .append("classe", cl)
          .append("carruagem", cr)
          .append("preço", p);

       return obj;
   }

   /*
   Retorna o nome do cliente com o número de cartão de cidadão igual ao do parâmetro
   */
   public static String getNome(int n)
   {
       String nome = null;
       String apelido = null;
          try {
              String sql = "select nome, apelido from Cliente where num_cc = " + n;
              Statement s = conn.createStatement();
              ResultSet res = s.executeQuery(sql);
              if(res.next())
              {
                  nome = res.getString("nome");
                  apelido = res.getString("apelido");
              }
           } catch (SQLException ex) {
               Logger.getLogger(Script.class.getName()).log(Level.SEVERE, null, ex);
           }
           return nome + " " + apelido;
    }

    public static void main(String[] args) 
    {
       try{
          Class.forName("com.mysql.jdbc.Driver");
          conn = DriverManager.getConnection(DB_URL, USER, PASS);
          Mongo mongo = new Mongo("localhost", 27017);
          DB db = mongo.getDB("polkaterra");
          DBCollection coll = db.getCollection("polkaterra");

          ResultSet rs, result;
          BasicDBObject doc;
          PreparedStatement stm, st;

          stmt = conn.prepareStatement("SELECT * FROM Comboio");
          rs = stmt.executeQuery();
          while(rs.next())
          {
              doc = new BasicDBObject();
              int id_comboio = rs.getInt("id_comboio");
              doc.append("comboio", id_comboio);
              stm = conn.prepareStatement("SELECT * from Lugar where id_comboio =?");
              stm.setInt(1, id_comboio);
              result = stm.executeQuery();
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
          stmt = conn.prepareStatement("SELECT * from Cliente");
          rs = stmt.executeQuery();

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
              stm = conn.prepareStatement("SELECT id_reserva from Reserva where id_cliente =?");
              stm.setInt(1, numcc);
              result = stm.executeQuery();
              List<BasicDBObject> reservas = new ArrayList<>();
              while(result.next())
              {
                  reservas.add(new BasicDBObject("número_reserva", result.getInt("id_reserva")));
              }
              doc.append("reservas", reservas);
              coll.insert(doc);
          }

          stmt = conn.prepareStatement("SELECT * from Viagem");
          rs = stmt.executeQuery();

          while(rs.next())
          {
              doc = new BasicDBObject();
              String viagem = rs.getString("id_viagem");
              float preço = rs.getFloat("preço");
              String origem = rs.getString("origem");
              String destino = rs.getString("destino");
              String hora = rs.getTime("hora").toString();
              String tipo = rs.getString("tipo");
              doc.append("código", viagem)
                 .append("origem", origem)
                 .append("destino", destino)
                 .append("hora", hora)
                 .append("tipo", tipo)
                 .append("preço", Math.round(preço*100d)/100d);
              List<BasicDBObject> datas = new ArrayList<>();
              stm = conn.prepareStatement("select * from ViagemComboio where id_viagem = ?");
              stm.setString(1, viagem);
              result = stm.executeQuery();
              while(result.next())
              {
                  int comboio = result.getInt("id_comboio");
                  String data = result.getDate("data").toString();
                  st = conn.prepareStatement("select * from Reserva where id_viagem = ? and data = ?");
                  st.setString(1, viagem);
                  st.setString(2, data);
                  ResultSet set = st.executeQuery();
                  List<BasicDBObject> reservas = new ArrayList<>();
                  while(set.next())
                  {
                      int reserva = set.getInt("id_reserva");
                      String lugar = set.getString("lugar");
                      int numcc = set.getInt("id_cliente");
                      String nome = getNome(numcc);
                      BasicDBObject obj = new BasicDBObject();
                      obj.append("número", reserva)
                         .append("nome", nome)
                         .append("CC", numcc)
                         .append("lugar", lugar);
                      reservas.add(obj);
                  }
                  BasicDBObject o = new BasicDBObject();
                  o.append("comboio", comboio)
                   .append("data", data)
                   .append("reservas", reservas);
                  datas.add(o);
              }
              doc.append("detalhes", datas);
              coll.insert(doc);
          }

       }
       catch(SQLException | ClassNotFoundException se)
       {
          System.out.println(se.getMessage());
       }
       finally
       {
          try
          {
             if(stmt!=null)
                conn.close();
          }
          catch(SQLException se){}
       }
    }
}

