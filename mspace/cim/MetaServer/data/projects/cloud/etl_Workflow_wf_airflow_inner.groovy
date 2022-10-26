import ru.neoflex.meta.utils.Context
def session = Context.current.txSession
def entity = session.createQuery("from etl.Workflow where name = :name").setParameter("name", "wf_airflow_inner").uniqueResult() 
entity.project = session.createQuery("from etl.Project where name = :name").setParameter("name", "cloud").uniqueResult()
entity.nodes.find {it.name == "Transformation_1"}.transformation = session.createQuery("from etl.Transformation where name = :name").setParameter("name", "tr_yandex_cloud_S3").uniqueResult()
Context.current.commit()
