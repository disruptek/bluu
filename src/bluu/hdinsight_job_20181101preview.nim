
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
  Call_JobSubmitHiveJob_567880 = ref object of OpenApiRestCall_567658
proc url_JobSubmitHiveJob_567882(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobSubmitHiveJob_567881(path: JsonNode; query: JsonNode;
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
  var valid_568041 = query.getOrDefault("user.name")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "user.name", valid_568041
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

proc call*(call_568065: Call_JobSubmitHiveJob_567880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a Hive job to an HDInsight cluster.
  ## 
  let valid = call_568065.validator(path, query, header, formData, body)
  let scheme = call_568065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568065.url(scheme.get, call_568065.host, call_568065.base,
                         call_568065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568065, url, valid)

proc call*(call_568136: Call_JobSubmitHiveJob_567880; content: JsonNode;
          userName: string): Recallable =
  ## jobSubmitHiveJob
  ## Submits a Hive job to an HDInsight cluster.
  ##   content: JObject (required)
  ##          : The content of the Hive job request.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var query_568137 = newJObject()
  var body_568139 = newJObject()
  if content != nil:
    body_568139 = content
  add(query_568137, "user.name", newJString(userName))
  result = call_568136.call(nil, query_568137, nil, nil, body_568139)

var jobSubmitHiveJob* = Call_JobSubmitHiveJob_567880(name: "jobSubmitHiveJob",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/templeton/v1/hive",
    validator: validate_JobSubmitHiveJob_567881, base: "",
    url: url_JobSubmitHiveJob_567882, schemes: {Scheme.Https})
type
  Call_JobList_568178 = ref object of OpenApiRestCall_567658
proc url_JobList_568180(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobList_568179(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568194 = query.getOrDefault("fields")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = newJString("*"))
  if valid_568194 != nil:
    section.add "fields", valid_568194
  var valid_568195 = query.getOrDefault("showall")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = newJString("true"))
  if valid_568195 != nil:
    section.add "showall", valid_568195
  var valid_568196 = query.getOrDefault("user.name")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "user.name", valid_568196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568197: Call_JobList_568178; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of jobs from the specified HDInsight cluster.
  ## 
  let valid = call_568197.validator(path, query, header, formData, body)
  let scheme = call_568197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568197.url(scheme.get, call_568197.host, call_568197.base,
                         call_568197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568197, url, valid)

proc call*(call_568198: Call_JobList_568178; userName: string; fields: string = "*";
          showall: string = "true"): Recallable =
  ## jobList
  ## Gets the list of jobs from the specified HDInsight cluster.
  ##   fields: string (required)
  ##         : If fields set to '*', the request will return full details of the job. Currently the value can only be '*'.
  ##   showall: string (required)
  ##          : If showall is set to 'true', the request will return all jobs the user has permission to view, not only the jobs belonging to the user.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var query_568199 = newJObject()
  add(query_568199, "fields", newJString(fields))
  add(query_568199, "showall", newJString(showall))
  add(query_568199, "user.name", newJString(userName))
  result = call_568198.call(nil, query_568199, nil, nil, nil)

var jobList* = Call_JobList_568178(name: "jobList", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/templeton/v1/jobs",
                                validator: validate_JobList_568179, base: "",
                                url: url_JobList_568180, schemes: {Scheme.Https})
type
  Call_JobGet_568200 = ref object of OpenApiRestCall_567658
proc url_JobGet_568202(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobGet_568201(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568217 = path.getOrDefault("jobId")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "jobId", valid_568217
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString (required)
  ##         : If fields set to '*', the request will return full details of the job. Currently the value can only be '*'.
  ##   user.name: JString (required)
  ##            : The user name used for running job.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `fields` field"
  var valid_568218 = query.getOrDefault("fields")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = newJString("*"))
  if valid_568218 != nil:
    section.add "fields", valid_568218
  var valid_568219 = query.getOrDefault("user.name")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "user.name", valid_568219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568220: Call_JobGet_568200; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets job details from the specified HDInsight cluster.
  ## 
  let valid = call_568220.validator(path, query, header, formData, body)
  let scheme = call_568220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568220.url(scheme.get, call_568220.host, call_568220.base,
                         call_568220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568220, url, valid)

proc call*(call_568221: Call_JobGet_568200; jobId: string; userName: string;
          fields: string = "*"): Recallable =
  ## jobGet
  ## Gets job details from the specified HDInsight cluster.
  ##   fields: string (required)
  ##         : If fields set to '*', the request will return full details of the job. Currently the value can only be '*'.
  ##   jobId: string (required)
  ##        : The id of the job.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var path_568222 = newJObject()
  var query_568223 = newJObject()
  add(query_568223, "fields", newJString(fields))
  add(path_568222, "jobId", newJString(jobId))
  add(query_568223, "user.name", newJString(userName))
  result = call_568221.call(path_568222, query_568223, nil, nil, nil)

var jobGet* = Call_JobGet_568200(name: "jobGet", meth: HttpMethod.HttpGet,
                              host: "azure.local",
                              route: "/templeton/v1/jobs/{jobId}",
                              validator: validate_JobGet_568201, base: "",
                              url: url_JobGet_568202, schemes: {Scheme.Https})
type
  Call_JobKill_568224 = ref object of OpenApiRestCall_567658
proc url_JobKill_568226(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobKill_568225(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568227 = path.getOrDefault("jobId")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "jobId", valid_568227
  result.add "path", section
  ## parameters in `query` object:
  ##   user.name: JString (required)
  ##            : The user name used for running job.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `user.name` field"
  var valid_568228 = query.getOrDefault("user.name")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "user.name", valid_568228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568229: Call_JobKill_568224; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates cancel on given running job in the specified HDInsight.
  ## 
  let valid = call_568229.validator(path, query, header, formData, body)
  let scheme = call_568229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568229.url(scheme.get, call_568229.host, call_568229.base,
                         call_568229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568229, url, valid)

proc call*(call_568230: Call_JobKill_568224; jobId: string; userName: string): Recallable =
  ## jobKill
  ## Initiates cancel on given running job in the specified HDInsight.
  ##   jobId: string (required)
  ##        : The id of the job.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var path_568231 = newJObject()
  var query_568232 = newJObject()
  add(path_568231, "jobId", newJString(jobId))
  add(query_568232, "user.name", newJString(userName))
  result = call_568230.call(path_568231, query_568232, nil, nil, nil)

var jobKill* = Call_JobKill_568224(name: "jobKill", meth: HttpMethod.HttpDelete,
                                host: "azure.local",
                                route: "/templeton/v1/jobs/{jobId}",
                                validator: validate_JobKill_568225, base: "",
                                url: url_JobKill_568226, schemes: {Scheme.Https})
type
  Call_JobListAfterJobId_568233 = ref object of OpenApiRestCall_567658
proc url_JobListAfterJobId_568235(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobListAfterJobId_568234(path: JsonNode; query: JsonNode;
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
  var valid_568236 = query.getOrDefault("fields")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = newJString("*"))
  if valid_568236 != nil:
    section.add "fields", valid_568236
  var valid_568237 = query.getOrDefault("numrecords")
  valid_568237 = validateParameter(valid_568237, JInt, required = false, default = nil)
  if valid_568237 != nil:
    section.add "numrecords", valid_568237
  var valid_568238 = query.getOrDefault("showall")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = newJString("true"))
  if valid_568238 != nil:
    section.add "showall", valid_568238
  var valid_568239 = query.getOrDefault("jobid")
  valid_568239 = validateParameter(valid_568239, JString, required = false,
                                 default = nil)
  if valid_568239 != nil:
    section.add "jobid", valid_568239
  var valid_568240 = query.getOrDefault("user.name")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "user.name", valid_568240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568241: Call_JobListAfterJobId_568233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets numrecords Of Jobs after jobid from the specified HDInsight cluster.
  ## 
  let valid = call_568241.validator(path, query, header, formData, body)
  let scheme = call_568241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568241.url(scheme.get, call_568241.host, call_568241.base,
                         call_568241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568241, url, valid)

proc call*(call_568242: Call_JobListAfterJobId_568233; userName: string;
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
  var query_568243 = newJObject()
  add(query_568243, "fields", newJString(fields))
  add(query_568243, "numrecords", newJInt(numrecords))
  add(query_568243, "showall", newJString(showall))
  add(query_568243, "jobid", newJString(jobid))
  add(query_568243, "user.name", newJString(userName))
  result = call_568242.call(nil, query_568243, nil, nil, nil)

var jobListAfterJobId* = Call_JobListAfterJobId_568233(name: "jobListAfterJobId",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/templeton/v1/jobs?op=LISTAFTERID",
    validator: validate_JobListAfterJobId_568234, base: "",
    url: url_JobListAfterJobId_568235, schemes: {Scheme.Https})
type
  Call_JobSubmitMapReduceJob_568244 = ref object of OpenApiRestCall_567658
proc url_JobSubmitMapReduceJob_568246(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobSubmitMapReduceJob_568245(path: JsonNode; query: JsonNode;
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
  var valid_568247 = query.getOrDefault("user.name")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "user.name", valid_568247
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

proc call*(call_568249: Call_JobSubmitMapReduceJob_568244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a MapReduce job to an HDInsight cluster.
  ## 
  let valid = call_568249.validator(path, query, header, formData, body)
  let scheme = call_568249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568249.url(scheme.get, call_568249.host, call_568249.base,
                         call_568249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568249, url, valid)

proc call*(call_568250: Call_JobSubmitMapReduceJob_568244; content: JsonNode;
          userName: string): Recallable =
  ## jobSubmitMapReduceJob
  ## Submits a MapReduce job to an HDInsight cluster.
  ##   content: JObject (required)
  ##          : The content of the MapReduce job request.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var query_568251 = newJObject()
  var body_568252 = newJObject()
  if content != nil:
    body_568252 = content
  add(query_568251, "user.name", newJString(userName))
  result = call_568250.call(nil, query_568251, nil, nil, body_568252)

var jobSubmitMapReduceJob* = Call_JobSubmitMapReduceJob_568244(
    name: "jobSubmitMapReduceJob", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/templeton/v1/mapreduce/jar",
    validator: validate_JobSubmitMapReduceJob_568245, base: "",
    url: url_JobSubmitMapReduceJob_568246, schemes: {Scheme.Https})
type
  Call_JobSubmitMapReduceStreamingJob_568253 = ref object of OpenApiRestCall_567658
proc url_JobSubmitMapReduceStreamingJob_568255(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobSubmitMapReduceStreamingJob_568254(path: JsonNode;
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
  var valid_568256 = query.getOrDefault("user.name")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "user.name", valid_568256
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

proc call*(call_568258: Call_JobSubmitMapReduceStreamingJob_568253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a MapReduce streaming job to an HDInsight cluster.
  ## 
  let valid = call_568258.validator(path, query, header, formData, body)
  let scheme = call_568258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568258.url(scheme.get, call_568258.host, call_568258.base,
                         call_568258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568258, url, valid)

proc call*(call_568259: Call_JobSubmitMapReduceStreamingJob_568253;
          content: JsonNode; userName: string): Recallable =
  ## jobSubmitMapReduceStreamingJob
  ## Submits a MapReduce streaming job to an HDInsight cluster.
  ##   content: JObject (required)
  ##          : The content of the MapReduce job request.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var query_568260 = newJObject()
  var body_568261 = newJObject()
  if content != nil:
    body_568261 = content
  add(query_568260, "user.name", newJString(userName))
  result = call_568259.call(nil, query_568260, nil, nil, body_568261)

var jobSubmitMapReduceStreamingJob* = Call_JobSubmitMapReduceStreamingJob_568253(
    name: "jobSubmitMapReduceStreamingJob", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/templeton/v1/mapreduce/streaming",
    validator: validate_JobSubmitMapReduceStreamingJob_568254, base: "",
    url: url_JobSubmitMapReduceStreamingJob_568255, schemes: {Scheme.Https})
type
  Call_JobSubmitPigJob_568262 = ref object of OpenApiRestCall_567658
proc url_JobSubmitPigJob_568264(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobSubmitPigJob_568263(path: JsonNode; query: JsonNode;
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
  var valid_568265 = query.getOrDefault("user.name")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "user.name", valid_568265
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

proc call*(call_568267: Call_JobSubmitPigJob_568262; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a Pig job to an HDInsight cluster.
  ## 
  let valid = call_568267.validator(path, query, header, formData, body)
  let scheme = call_568267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568267.url(scheme.get, call_568267.host, call_568267.base,
                         call_568267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568267, url, valid)

proc call*(call_568268: Call_JobSubmitPigJob_568262; content: JsonNode;
          userName: string): Recallable =
  ## jobSubmitPigJob
  ## Submits a Pig job to an HDInsight cluster.
  ##   content: JObject (required)
  ##          : The content of the Pig job request.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var query_568269 = newJObject()
  var body_568270 = newJObject()
  if content != nil:
    body_568270 = content
  add(query_568269, "user.name", newJString(userName))
  result = call_568268.call(nil, query_568269, nil, nil, body_568270)

var jobSubmitPigJob* = Call_JobSubmitPigJob_568262(name: "jobSubmitPigJob",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/templeton/v1/pig",
    validator: validate_JobSubmitPigJob_568263, base: "", url: url_JobSubmitPigJob_568264,
    schemes: {Scheme.Https})
type
  Call_JobSubmitSqoopJob_568271 = ref object of OpenApiRestCall_567658
proc url_JobSubmitSqoopJob_568273(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobSubmitSqoopJob_568272(path: JsonNode; query: JsonNode;
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
  var valid_568274 = query.getOrDefault("user.name")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "user.name", valid_568274
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

proc call*(call_568276: Call_JobSubmitSqoopJob_568271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a Sqoop job to an HDInsight cluster.
  ## 
  let valid = call_568276.validator(path, query, header, formData, body)
  let scheme = call_568276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568276.url(scheme.get, call_568276.host, call_568276.base,
                         call_568276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568276, url, valid)

proc call*(call_568277: Call_JobSubmitSqoopJob_568271; content: JsonNode;
          userName: string): Recallable =
  ## jobSubmitSqoopJob
  ## Submits a Sqoop job to an HDInsight cluster.
  ##   content: JObject (required)
  ##          : The content of the Sqoop job request.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var query_568278 = newJObject()
  var body_568279 = newJObject()
  if content != nil:
    body_568279 = content
  add(query_568278, "user.name", newJString(userName))
  result = call_568277.call(nil, query_568278, nil, nil, body_568279)

var jobSubmitSqoopJob* = Call_JobSubmitSqoopJob_568271(name: "jobSubmitSqoopJob",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/templeton/v1/sqoop",
    validator: validate_JobSubmitSqoopJob_568272, base: "",
    url: url_JobSubmitSqoopJob_568273, schemes: {Scheme.Https})
type
  Call_JobGetAppState_568280 = ref object of OpenApiRestCall_567658
proc url_JobGetAppState_568282(protocol: Scheme; host: string; base: string;
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

proc validate_JobGetAppState_568281(path: JsonNode; query: JsonNode;
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
  var valid_568283 = path.getOrDefault("appId")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "appId", valid_568283
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568284: Call_JobGetAppState_568280; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets application state from the specified HDInsight cluster.
  ## 
  let valid = call_568284.validator(path, query, header, formData, body)
  let scheme = call_568284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568284.url(scheme.get, call_568284.host, call_568284.base,
                         call_568284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568284, url, valid)

proc call*(call_568285: Call_JobGetAppState_568280; appId: string): Recallable =
  ## jobGetAppState
  ## Gets application state from the specified HDInsight cluster.
  ##   appId: string (required)
  ##        : The id of the job.
  var path_568286 = newJObject()
  add(path_568286, "appId", newJString(appId))
  result = call_568285.call(path_568286, nil, nil, nil, nil)

var jobGetAppState* = Call_JobGetAppState_568280(name: "jobGetAppState",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/ws/v1/cluster/apps/{appId}/state",
    validator: validate_JobGetAppState_568281, base: "", url: url_JobGetAppState_568282,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
