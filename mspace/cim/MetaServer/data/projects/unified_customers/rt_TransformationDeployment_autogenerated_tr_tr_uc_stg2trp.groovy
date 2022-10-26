import ru.neoflex.meta.utils.Context
def session = Context.current.txSession
def entity = session.createQuery("from rt.TransformationDeployment where name = :name").setParameter("name", "autogenerated_tr_tr_uc_stg2trp").uniqueResult() 
entity.deployments.clear()
entity.project = session.createQuery("from etl.Project where name = :name").setParameter("name", "unified_customers").uniqueResult()
entity.livyServer = session.createQuery("from rt.LivyServer where name = :name").setParameter("name", "bd-livy").uniqueResult()
entity.transformation = session.createQuery("from etl.Transformation where name = :name").setParameter("name", "tr_uc_stg2trp").uniqueResult()
entity.deployments.add(session.createQuery("from rt.Deployment where name = :name").setParameter("name", "customers").uniqueResult())
Context.current.commit()
