import ru.neoflex.meta.utils.Context
def session = Context.current.txSession
def entity = session.createQuery("from rt.LivyServer where name = :name").setParameter("name", "s3-livy").uniqueResult() 
entity.project = session.createQuery("from etl.Project where name = :name").setParameter("name", "cloud").uniqueResult()
entity.filesystem = session.createQuery("from rt.FileSystem where name = :name").setParameter("name", "s3datagram").uniqueResult()
Context.current.commit()
