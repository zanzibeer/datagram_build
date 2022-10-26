import ru.neoflex.meta.utils.Context
def session = Context.current.txSession
def entity = session.createQuery("from etl.Transformation where name = :name").setParameter("name", "tr_google_big_query_to_yandex_click_house").uniqueResult() 
entity.userDefinedFunctions.clear()
entity.mavenDependencies.clear()
entity.project = session.createQuery("from etl.Project where name = :name").setParameter("name", "cloud").uniqueResult()
entity.targets.find {it.name == "CickHouse_Covid19"}.context = null
entity.sources.find {it.name == "BigQuery_Covid19"}.context = null
Context.current.commit()
