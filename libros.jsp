<%@page contentType="text/html" pageEncoding="iso-8859-1" import="java.sql.*,net.ucanaccess.jdbc.*" %>
 <html>
 <head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <title>Actualizar, Eliminar, Crear registros.</title>
 </head>
 <body>
 
<%
String actualizarLibro= request.getParameter("Action");
ServletContext context= request.getServletContext();
String path = context.getRealPath("/data");

String tituloLibroActualizar="";
String isbnLibroActualizar="";

ResultSet rsLibro=null;
Connection conexion = getConnection(path);
    if(!conexion.isClosed() && actualizarLibro!=null){
        java.sql.PreparedStatement ps= conexion.prepareStatement("Select * from libros where isbn=?");
        ps.setString(1,request.getParameter("isbn"));
        rsLibro= ps.executeQuery();
    }
    if(rsLibro!=null){
        while(rsLibro.next()){
           tituloLibroActualizar= rsLibro.getString("titulo");
           isbnLibroActualizar = rsLibro.getString("isbn");
       }
    }
%>

<H1>MANTENIMIENTO DE LIBROS</H1>
<form action="matto.jsp" method="post" name="Actualizar">
 <table>
 <tr>
     <td>ISBN<input type="text" name="isbn" value="<%=(isbnLibroActualizar!=null)?isbnLibroActualizar:""%>" readonly="<%=(actualizarLibro!=null)?"true":"false"%>" size="40"/>
</td>
  </tr>
 <tr>
 <td>Tï¿½tulo<input type="text" name="titulo" value="<%=(tituloLibroActualizar!=null)?tituloLibroActualizar:""%>" size="50"/></td>
 </tr>
 <tr><td> Action <input type="radio" name="Action" value="Actualizar" <%=(actualizarLibro!=null)?"checked":""%> /> Actualizar
 <input type="radio" name="Action" value="Eliminar" /> Eliminar
 <input type="radio" name="Action" value="Crear" <%=(actualizarLibro==null)?"checked":""%>/> Crear
  </td>
 <td><input type="SUBMIT" value="ACEPTAR" />
</td>
 </tr>
 </form>
 </tr>
 </table>
 </form>
<br><br>
<%!
public Connection getConnection(String path) throws SQLException {
String driver = "sun.jdbc.odbc.JdbcOdbcDriver";
String filePath= path+"\\datos.mdb";
String userName="",password="";
String fullConnectionString = "jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=" + filePath;

    Connection conn = null;
try{
        Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
 conn = DriverManager.getConnection(fullConnectionString,userName,password);

}
 catch (Exception e) {
System.out.println("Error: " + e);
 }
    return conn;
}

//metodo para obtenere los libros de manara ascendente o de manera descendente
public ResultSet getUserQuery(Statement st, String tableOrder)throws SQLException{
        ResultSet rs=null;
        try{
            if (tableOrder==null){
                rs=st.executeQuery("Select * from libros");
            }
            else if(tableOrder.equals("ascendente")){
                rs=st.executeQuery("Select * from libros order by titulo asc");
            }
            else if(tableOrder.equals("descendente")){
                rs=st.executeQuery("Select * from libros order by titulo desc");
            }
        }
        catch(Exception e){
            System.out.println("Error: "+e);
        }
        return rs;
    }

public ResultSet getTitleFilter(Connection c, String tituloFiltro) throws SQLException{
    String consulta="Select * from libros where titulo like ?";
    ResultSet rs= null;
    java.sql.PreparedStatement ps= c.prepareStatement(consulta);
    ps.setString(1,tituloFiltro);
    System.out.println(ps);
    try{
        rs= ps.executeQuery();
    }
    catch(Exception e){
        System.out.println("Error: "+ e);
    }
    return rs;
}

%>


<%
//ServletContext context= request.getServletContext();
//String path = context.getRealPath("/data");
//Connection conexion = getConnection(path);

String tableOrder= request.getParameter("orden");
//obtener la direccion de matto para poder crear la url para el enlace de eliminar
String url_completo_eliminar="";
String url_completo_actualizar="";
//datos de los libros
String titulo;
String isbn;
String tituloFiltro= request.getParameter("tituloFiltro");
   if (!conexion.isClosed()){
   out.write("OK");
 
      Statement st = conexion.createStatement();
      //selección del tipo de consulta para el orden de la tabla
      ResultSet rs= getUserQuery(st,tableOrder);
      if(rs==null){
            out.println("NO se obtuvo nada con la consulta");
        }
        else {
        
      //formulario buscar por isbn
      %>
      
        <form name="formbusca" action="libros.jsp" method="post">
            Titulo a buscar: <input type=text name="tituloFiltro" placeholder="ingrese un titulo o parte de el" un título?> 
            <input type=submit name=buscar value=BUSCAR>
        </form>

      <%
      // Ponemos los resultados en un table de html
      if(tituloFiltro==null){
                out.println("<table border=\"1\"><tr><td>Num.</td><td>ISBN</td><td>Titulo <a href="+"libros.jsp?orden=ascendente>"+"asc"+"</a> <a href="+"libros.jsp?orden=descendente>"+"desc"+"</a> </td><td>Acciï¿½n</td></tr>");
      int i=1;
      while (rs.next())
      {
         isbn= rs.getString("isbn");
         titulo=rs.getString("titulo");
         url_completo_eliminar="matto.jsp?isbn="+isbn+"&Action="+"Eliminar";
         url_completo_actualizar="libros.jsp?isbn="+isbn+"&Action="+"Actualizar";
         out.println("<tr>");
         out.println("<td>"+ i +"</td>");
         out.println("<td>"+isbn+"</td>");
         out.println("<td>"+titulo+"</td>");
            out.println("<td>");
            out.println("<a href= "+url_completo_eliminar+"Eliminar"+" style= display:block; >"+"Eliminar"+"</a>");
            out.println("<a href= "+url_completo_actualizar+"Actualizar"+">"+"Actualizar"+"</a>");
            out.println("</td>");
         out.println("</tr>");
         i++;
      }
      out.println("</table>");

      // cierre de la conexion
      conexion.close();
      }
      else if(tituloFiltro!=null){
            rs=getTitleFilter(conexion,tituloFiltro);
            if(rs!=null){
            out.println("<table border=\"1\">");
            out.println("<tr><td>Num.</td><td>ISBN</td><td>Titulo</td></tr>");
            int i=1;
            while(rs.next()){
                isbn=rs.getString("isbn");
                titulo= rs.getString("titulo");
                out.println("<tr>");
                out.println("<td>"+i+"</td>");
                out.println("<td>"+isbn+"</td>");
                out.println("<td>"+titulo+"</td>");
                out.println("</tr>");
                i++;
              }             
             out.println("</table>");
             out.println("<a href='libros.jsp'>Mostrar todos los libros</a>");
            }
          }
          conexion.close();
    }
}

%>
 </body>