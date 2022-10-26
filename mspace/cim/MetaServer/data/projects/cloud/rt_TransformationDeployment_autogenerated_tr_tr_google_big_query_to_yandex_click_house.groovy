import ru.neoflex.meta.utils.Context
def session = Context.current.txSession
def entity = session.createQuery("from rt.TransformationDeployment where name = :name").setParameter("name", "autogenerated_tr_tr_google_big_query_to_yandex_click_house").uniqueResult() 
entity.deployments.clear()
entity.project = session.createQuery("from etl.Project where name = :name").setParameter("name", "cloud").uniqueResult()
entity.livyServer = session.createQuery("from rt.LivyServer where name = :name").setParameter("name", "s3-livy").uniqueResult()
entity.transformation = session.createQuery("from etl.Transformation where name = :name").setParameter("name", "tr_google_big_query_to_yandex_click_house").uniqueResult()
Context.current.commit()