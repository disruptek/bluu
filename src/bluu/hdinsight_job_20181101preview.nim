
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: HDInsightJobManagementClient
## version: 2018-11-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The HDInsight Job Client.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "hdinsight-job"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobSubmitHiveJob_593647 = ref object of OpenApiRestCall_593425
proc url_JobSubmitHiveJob_593649(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobSubmitHiveJob_593648(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Submits a Hive job to an HDInsight cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   user.name: JString (required)
  ##            : The user name used for running job.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `user.name` field"
  var valid_593808 = query.getOrDefault("user.name")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "user.name", valid_593808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   content: JObject (required)
  ##          : The content of the Hive job request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593832: Call_JobSubmitHiveJob_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a Hive job to an HDInsight cluster.
  ## 
  let valid = call_593832.validator(path, query, header, formData, body)
  let scheme = call_593832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593832.url(scheme.get, call_593832.host, call_593832.base,
                         call_593832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593832, url, valid)

proc call*(call_593903: Call_JobSubmitHiveJob_593647; content: JsonNode;
          userName: string): Recallable =
  ## jobSubmitHiveJob
  ## Submits a Hive job to an HDInsight cluster.
  ##   content: JObject (required)
  ##          : The content of the Hive job request.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var query_593904 = newJObject()
  var body_593906 = newJObject()
  if content != nil:
    body_593906 = content
  add(query_593904, "user.name", newJString(userName))
  result = call_593903.call(nil, query_593904, nil, nil, body_593906)

var jobSubmitHiveJob* = Call_JobSubmitHiveJob_593647(name: "jobSubmitHiveJob",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/templeton/v1/hive",
    validator: validate_JobSubmitHiveJob_593648, base: "",
    url: url_JobSubmitHiveJob_593649, schemes: {Scheme.Https})
type
  Call_JobList_593945 = ref object of OpenApiRestCall_593425
proc url_JobList_593947(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobList_593946(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of jobs from the specified HDInsight cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString (required)
  ##         : If fields set to '*', the request will return full details of the job. Currently the value can only be '*'.
  ##   showall: JString (required)
  ##          : If showall is set to 'true', the request will return all jobs the user has permission to view, not only the jobs belonging to the user.
  ##   user.name: JString (required)
  ##            : The user name used for running job.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `fields` field"
  var valid_593961 = query.getOrDefault("fields")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = newJString("*"))
  if valid_593961 != nil:
    section.add "fields", valid_593961
  var valid_593962 = query.getOrDefault("showall")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = newJString("true"))
  if valid_593962 != nil:
    section.add "showall", valid_593962
  var valid_593963 = query.getOrDefault("user.name")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "user.name", valid_593963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593964: Call_JobList_593945; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of jobs from the specified HDInsight cluster.
  ## 
  let valid = call_593964.validator(path, query, header, formData, body)
  let scheme = call_593964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593964.url(scheme.get, call_593964.host, call_593964.base,
                         call_593964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593964, url, valid)

proc call*(call_593965: Call_JobList_593945; userName: string; fields: string = "*";
          showall: string = "true"): Recallable =
  ## jobList
  ## Gets the list of jobs from the specified HDInsight cluster.
  ##   fields: string (required)
  ##         : If fields set to '*', the request will return full details of the job. Currently the value can only be '*'.
  ##   showall: string (required)
  ##          : If showall is set to 'true', the request will return all jobs the user has permission to view, not only the jobs belonging to the user.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var query_593966 = newJObject()
  add(query_593966, "fields", newJString(fields))
  add(query_593966, "showall", newJString(showall))
  add(query_593966, "user.name", newJString(userName))
  result = call_593965.call(nil, query_593966, nil, nil, nil)

var jobList* = Call_JobList_593945(name: "jobList", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/templeton/v1/jobs",
                                validator: validate_JobList_593946, base: "",
                                url: url_JobList_593947, schemes: {Scheme.Https})
type
  Call_JobGet_593967 = ref object of OpenApiRestCall_593425
proc url_JobGet_593969(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/templeton/v1/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobGet_593968(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets job details from the specified HDInsight cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The id of the job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_593984 = path.getOrDefault("jobId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "jobId", valid_593984
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString (required)
  ##         : If fields set to '*', the request will return full details of the job. Currently the value can only be '*'.
  ##   user.name: JString (required)
  ##            : The user name used for running job.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `fields` field"
  var valid_593985 = query.getOrDefault("fields")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = newJString("*"))
  if valid_593985 != nil:
    section.add "fields", valid_593985
  var valid_593986 = query.getOrDefault("user.name")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "user.name", valid_593986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_JobGet_593967; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets job details from the specified HDInsight cluster.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_JobGet_593967; jobId: string; userName: string;
          fields: string = "*"): Recallable =
  ## jobGet
  ## Gets job details from the specified HDInsight cluster.
  ##   fields: string (required)
  ##         : If fields set to '*', the request will return full details of the job. Currently the value can only be '*'.
  ##   jobId: string (required)
  ##        : The id of the job.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  add(query_593990, "fields", newJString(fields))
  add(path_593989, "jobId", newJString(jobId))
  add(query_593990, "user.name", newJString(userName))
  result = call_593988.call(path_593989, query_593990, nil, nil, nil)

var jobGet* = Call_JobGet_593967(name: "jobGet", meth: HttpMethod.HttpGet,
                              host: "azure.local",
                              route: "/templeton/v1/jobs/{jobId}",
                              validator: validate_JobGet_593968, base: "",
                              url: url_JobGet_593969, schemes: {Scheme.Https})
type
  Call_JobKill_593991 = ref object of OpenApiRestCall_593425
proc url_JobKill_593993(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/templeton/v1/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobKill_593992(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiates cancel on given running job in the specified HDInsight.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The id of the job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_593994 = path.getOrDefault("jobId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "jobId", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   user.name: JString (required)
  ##            : The user name used for running job.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `user.name` field"
  var valid_593995 = query.getOrDefault("user.name")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "user.name", valid_593995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593996: Call_JobKill_593991; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates cancel on given running job in the specified HDInsight.
  ## 
  let valid = call_593996.validator(path, query, header, formData, body)
  let scheme = call_593996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593996.url(scheme.get, call_593996.host, call_593996.base,
                         call_593996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593996, url, valid)

proc call*(call_593997: Call_JobKill_593991; jobId: string; userName: string): Recallable =
  ## jobKill
  ## Initiates cancel on given running job in the specified HDInsight.
  ##   jobId: string (required)
  ##        : The id of the job.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var path_593998 = newJObject()
  var query_593999 = newJObject()
  add(path_593998, "jobId", newJString(jobId))
  add(query_593999, "user.name", newJString(userName))
  result = call_593997.call(path_593998, query_593999, nil, nil, nil)

var jobKill* = Call_JobKill_593991(name: "jobKill", meth: HttpMethod.HttpDelete,
                                host: "azure.local",
                                route: "/templeton/v1/jobs/{jobId}",
                                validator: validate_JobKill_593992, base: "",
                                url: url_JobKill_593993, schemes: {Scheme.Https})
type
  Call_JobListAfterJobId_594000 = ref object of OpenApiRestCall_593425
proc url_JobListAfterJobId_594002(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobListAfterJobId_594001(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets numrecords Of Jobs after jobid from the specified HDInsight cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString (required)
  ##         : If fields set to '*', the request will return full details of the job. Currently the value can only be '*'.
  ##   numrecords: JInt
  ##             : Number of jobs to fetch.
  ##   showall: JString (required)
  ##          : If showall is set to 'true', the request will return all jobs the user has permission to view, not only the jobs belonging to the user.
  ##   jobid: JString
  ##        : JobId from where to list jobs.
  ##   user.name: JString (required)
  ##            : The user name used for running job.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `fields` field"
  var valid_594003 = query.getOrDefault("fields")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = newJString("*"))
  if valid_594003 != nil:
    section.add "fields", valid_594003
  var valid_594004 = query.getOrDefault("numrecords")
  valid_594004 = validateParameter(valid_594004, JInt, required = false, default = nil)
  if valid_594004 != nil:
    section.add "numrecords", valid_594004
  var valid_594005 = query.getOrDefault("showall")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = newJString("true"))
  if valid_594005 != nil:
    section.add "showall", valid_594005
  var valid_594006 = query.getOrDefault("jobid")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "jobid", valid_594006
  var valid_594007 = query.getOrDefault("user.name")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "user.name", valid_594007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594008: Call_JobListAfterJobId_594000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets numrecords Of Jobs after jobid from the specified HDInsight cluster.
  ## 
  let valid = call_594008.validator(path, query, header, formData, body)
  let scheme = call_594008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594008.url(scheme.get, call_594008.host, call_594008.base,
                         call_594008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594008, url, valid)

proc call*(call_594009: Call_JobListAfterJobId_594000; userName: string;
          fields: string = "*"; numrecords: int = 0; showall: string = "true";
          jobid: string = ""): Recallable =
  ## jobListAfterJobId
  ## Gets numrecords Of Jobs after jobid from the specified HDInsight cluster.
  ##   fields: string (required)
  ##         : If fields set to '*', the request will return full details of the job. Currently the value can only be '*'.
  ##   numrecords: int
  ##             : Number of jobs to fetch.
  ##   showall: string (required)
  ##          : If showall is set to 'true', the request will return all jobs the user has permission to view, not only the jobs belonging to the user.
  ##   jobid: string
  ##        : JobId from where to list jobs.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var query_594010 = newJObject()
  add(query_594010, "fields", newJString(fields))
  add(query_594010, "numrecords", newJInt(numrecords))
  add(query_594010, "showall", newJString(showall))
  add(query_594010, "jobid", newJString(jobid))
  add(query_594010, "user.name", newJString(userName))
  result = call_594009.call(nil, query_594010, nil, nil, nil)

var jobListAfterJobId* = Call_JobListAfterJobId_594000(name: "jobListAfterJobId",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/templeton/v1/jobs?op=LISTAFTERID",
    validator: validate_JobListAfterJobId_594001, base: "",
    url: url_JobListAfterJobId_594002, schemes: {Scheme.Https})
type
  Call_JobSubmitMapReduceJob_594011 = ref object of OpenApiRestCall_593425
proc url_JobSubmitMapReduceJob_594013(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobSubmitMapReduceJob_594012(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Submits a MapReduce job to an HDInsight cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   user.name: JString (required)
  ##            : The user name used for running job.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `user.name` field"
  var valid_594014 = query.getOrDefault("user.name")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "user.name", valid_594014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   content: JObject (required)
  ##          : The content of the MapReduce job request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594016: Call_JobSubmitMapReduceJob_594011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a MapReduce job to an HDInsight cluster.
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_JobSubmitMapReduceJob_594011; content: JsonNode;
          userName: string): Recallable =
  ## jobSubmitMapReduceJob
  ## Submits a MapReduce job to an HDInsight cluster.
  ##   content: JObject (required)
  ##          : The content of the MapReduce job request.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var query_594018 = newJObject()
  var body_594019 = newJObject()
  if content != nil:
    body_594019 = content
  add(query_594018, "user.name", newJString(userName))
  result = call_594017.call(nil, query_594018, nil, nil, body_594019)

var jobSubmitMapReduceJob* = Call_JobSubmitMapReduceJob_594011(
    name: "jobSubmitMapReduceJob", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/templeton/v1/mapreduce/jar",
    validator: validate_JobSubmitMapReduceJob_594012, base: "",
    url: url_JobSubmitMapReduceJob_594013, schemes: {Scheme.Https})
type
  Call_JobSubmitMapReduceStreamingJob_594020 = ref object of OpenApiRestCall_593425
proc url_JobSubmitMapReduceStreamingJob_594022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobSubmitMapReduceStreamingJob_594021(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Submits a MapReduce streaming job to an HDInsight cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   user.name: JString (required)
  ##            : The user name used for running job.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `user.name` field"
  var valid_594023 = query.getOrDefault("user.name")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "user.name", valid_594023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   content: JObject (required)
  ##          : The content of the MapReduce job request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594025: Call_JobSubmitMapReduceStreamingJob_594020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a MapReduce streaming job to an HDInsight cluster.
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_JobSubmitMapReduceStreamingJob_594020;
          content: JsonNode; userName: string): Recallable =
  ## jobSubmitMapReduceStreamingJob
  ## Submits a MapReduce streaming job to an HDInsight cluster.
  ##   content: JObject (required)
  ##          : The content of the MapReduce job request.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var query_594027 = newJObject()
  var body_594028 = newJObject()
  if content != nil:
    body_594028 = content
  add(query_594027, "user.name", newJString(userName))
  result = call_594026.call(nil, query_594027, nil, nil, body_594028)

var jobSubmitMapReduceStreamingJob* = Call_JobSubmitMapReduceStreamingJob_594020(
    name: "jobSubmitMapReduceStreamingJob", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/templeton/v1/mapreduce/streaming",
    validator: validate_JobSubmitMapReduceStreamingJob_594021, base: "",
    url: url_JobSubmitMapReduceStreamingJob_594022, schemes: {Scheme.Https})
type
  Call_JobSubmitPigJob_594029 = ref object of OpenApiRestCall_593425
proc url_JobSubmitPigJob_594031(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobSubmitPigJob_594030(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Submits a Pig job to an HDInsight cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   user.name: JString (required)
  ##            : The user name used for running job.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `user.name` field"
  var valid_594032 = query.getOrDefault("user.name")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "user.name", valid_594032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   content: JObject (required)
  ##          : The content of the Pig job request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594034: Call_JobSubmitPigJob_594029; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a Pig job to an HDInsight cluster.
  ## 
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_JobSubmitPigJob_594029; content: JsonNode;
          userName: string): Recallable =
  ## jobSubmitPigJob
  ## Submits a Pig job to an HDInsight cluster.
  ##   content: JObject (required)
  ##          : The content of the Pig job request.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var query_594036 = newJObject()
  var body_594037 = newJObject()
  if content != nil:
    body_594037 = content
  add(query_594036, "user.name", newJString(userName))
  result = call_594035.call(nil, query_594036, nil, nil, body_594037)

var jobSubmitPigJob* = Call_JobSubmitPigJob_594029(name: "jobSubmitPigJob",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/templeton/v1/pig",
    validator: validate_JobSubmitPigJob_594030, base: "", url: url_JobSubmitPigJob_594031,
    schemes: {Scheme.Https})
type
  Call_JobSubmitSqoopJob_594038 = ref object of OpenApiRestCall_593425
proc url_JobSubmitSqoopJob_594040(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobSubmitSqoopJob_594039(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Submits a Sqoop job to an HDInsight cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   user.name: JString (required)
  ##            : The user name used for running job.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `user.name` field"
  var valid_594041 = query.getOrDefault("user.name")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "user.name", valid_594041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   content: JObject (required)
  ##          : The content of the Sqoop job request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594043: Call_JobSubmitSqoopJob_594038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a Sqoop job to an HDInsight cluster.
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_JobSubmitSqoopJob_594038; content: JsonNode;
          userName: string): Recallable =
  ## jobSubmitSqoopJob
  ## Submits a Sqoop job to an HDInsight cluster.
  ##   content: JObject (required)
  ##          : The content of the Sqoop job request.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var query_594045 = newJObject()
  var body_594046 = newJObject()
  if content != nil:
    body_594046 = content
  add(query_594045, "user.name", newJString(userName))
  result = call_594044.call(nil, query_594045, nil, nil, body_594046)

var jobSubmitSqoopJob* = Call_JobSubmitSqoopJob_594038(name: "jobSubmitSqoopJob",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/templeton/v1/sqoop",
    validator: validate_JobSubmitSqoopJob_594039, base: "",
    url: url_JobSubmitSqoopJob_594040, schemes: {Scheme.Https})
type
  Call_JobGetAppState_594047 = ref object of OpenApiRestCall_593425
proc url_JobGetAppState_594049(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/ws/v1/cluster/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/state")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobGetAppState_594048(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets application state from the specified HDInsight cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The id of the job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_594050 = path.getOrDefault("appId")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "appId", valid_594050
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594051: Call_JobGetAppState_594047; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets application state from the specified HDInsight cluster.
  ## 
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_JobGetAppState_594047; appId: string): Recallable =
  ## jobGetAppState
  ## Gets application state from the specified HDInsight cluster.
  ##   appId: string (required)
  ##        : The id of the job.
  var path_594053 = newJObject()
  add(path_594053, "appId", newJString(appId))
  result = call_594052.call(path_594053, nil, nil, nil, nil)

var jobGetAppState* = Call_JobGetAppState_594047(name: "jobGetAppState",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/ws/v1/cluster/apps/{appId}/state",
    validator: validate_JobGetAppState_594048, base: "", url: url_JobGetAppState_594049,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
