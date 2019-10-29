
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "hdinsight-job"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobSubmitHiveJob_563778 = ref object of OpenApiRestCall_563556
proc url_JobSubmitHiveJob_563780(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobSubmitHiveJob_563779(path: JsonNode; query: JsonNode;
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
  var valid_563941 = query.getOrDefault("user.name")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "user.name", valid_563941
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

proc call*(call_563965: Call_JobSubmitHiveJob_563778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a Hive job to an HDInsight cluster.
  ## 
  let valid = call_563965.validator(path, query, header, formData, body)
  let scheme = call_563965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563965.url(scheme.get, call_563965.host, call_563965.base,
                         call_563965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563965, url, valid)

proc call*(call_564036: Call_JobSubmitHiveJob_563778; userName: string;
          content: JsonNode): Recallable =
  ## jobSubmitHiveJob
  ## Submits a Hive job to an HDInsight cluster.
  ##   userName: string (required)
  ##           : The user name used for running job.
  ##   content: JObject (required)
  ##          : The content of the Hive job request.
  var query_564037 = newJObject()
  var body_564039 = newJObject()
  add(query_564037, "user.name", newJString(userName))
  if content != nil:
    body_564039 = content
  result = call_564036.call(nil, query_564037, nil, nil, body_564039)

var jobSubmitHiveJob* = Call_JobSubmitHiveJob_563778(name: "jobSubmitHiveJob",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/templeton/v1/hive",
    validator: validate_JobSubmitHiveJob_563779, base: "",
    url: url_JobSubmitHiveJob_563780, schemes: {Scheme.Https})
type
  Call_JobList_564078 = ref object of OpenApiRestCall_563556
proc url_JobList_564080(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobList_564079(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of jobs from the specified HDInsight cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   user.name: JString (required)
  ##            : The user name used for running job.
  ##   showall: JString (required)
  ##          : If showall is set to 'true', the request will return all jobs the user has permission to view, not only the jobs belonging to the user.
  ##   fields: JString (required)
  ##         : If fields set to '*', the request will return full details of the job. Currently the value can only be '*'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `user.name` field"
  var valid_564081 = query.getOrDefault("user.name")
  valid_564081 = validateParameter(valid_564081, JString, required = true,
                                 default = nil)
  if valid_564081 != nil:
    section.add "user.name", valid_564081
  var valid_564095 = query.getOrDefault("showall")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = newJString("true"))
  if valid_564095 != nil:
    section.add "showall", valid_564095
  var valid_564096 = query.getOrDefault("fields")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = newJString("*"))
  if valid_564096 != nil:
    section.add "fields", valid_564096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564097: Call_JobList_564078; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of jobs from the specified HDInsight cluster.
  ## 
  let valid = call_564097.validator(path, query, header, formData, body)
  let scheme = call_564097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564097.url(scheme.get, call_564097.host, call_564097.base,
                         call_564097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564097, url, valid)

proc call*(call_564098: Call_JobList_564078; userName: string;
          showall: string = "true"; fields: string = "*"): Recallable =
  ## jobList
  ## Gets the list of jobs from the specified HDInsight cluster.
  ##   userName: string (required)
  ##           : The user name used for running job.
  ##   showall: string (required)
  ##          : If showall is set to 'true', the request will return all jobs the user has permission to view, not only the jobs belonging to the user.
  ##   fields: string (required)
  ##         : If fields set to '*', the request will return full details of the job. Currently the value can only be '*'.
  var query_564099 = newJObject()
  add(query_564099, "user.name", newJString(userName))
  add(query_564099, "showall", newJString(showall))
  add(query_564099, "fields", newJString(fields))
  result = call_564098.call(nil, query_564099, nil, nil, nil)

var jobList* = Call_JobList_564078(name: "jobList", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/templeton/v1/jobs",
                                validator: validate_JobList_564079, base: "",
                                url: url_JobList_564080, schemes: {Scheme.Https})
type
  Call_JobGet_564100 = ref object of OpenApiRestCall_563556
proc url_JobGet_564102(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobGet_564101(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564117 = path.getOrDefault("jobId")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "jobId", valid_564117
  result.add "path", section
  ## parameters in `query` object:
  ##   user.name: JString (required)
  ##            : The user name used for running job.
  ##   fields: JString (required)
  ##         : If fields set to '*', the request will return full details of the job. Currently the value can only be '*'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `user.name` field"
  var valid_564118 = query.getOrDefault("user.name")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "user.name", valid_564118
  var valid_564119 = query.getOrDefault("fields")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = newJString("*"))
  if valid_564119 != nil:
    section.add "fields", valid_564119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564120: Call_JobGet_564100; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets job details from the specified HDInsight cluster.
  ## 
  let valid = call_564120.validator(path, query, header, formData, body)
  let scheme = call_564120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564120.url(scheme.get, call_564120.host, call_564120.base,
                         call_564120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564120, url, valid)

proc call*(call_564121: Call_JobGet_564100; jobId: string; userName: string;
          fields: string = "*"): Recallable =
  ## jobGet
  ## Gets job details from the specified HDInsight cluster.
  ##   jobId: string (required)
  ##        : The id of the job.
  ##   userName: string (required)
  ##           : The user name used for running job.
  ##   fields: string (required)
  ##         : If fields set to '*', the request will return full details of the job. Currently the value can only be '*'.
  var path_564122 = newJObject()
  var query_564123 = newJObject()
  add(path_564122, "jobId", newJString(jobId))
  add(query_564123, "user.name", newJString(userName))
  add(query_564123, "fields", newJString(fields))
  result = call_564121.call(path_564122, query_564123, nil, nil, nil)

var jobGet* = Call_JobGet_564100(name: "jobGet", meth: HttpMethod.HttpGet,
                              host: "azure.local",
                              route: "/templeton/v1/jobs/{jobId}",
                              validator: validate_JobGet_564101, base: "",
                              url: url_JobGet_564102, schemes: {Scheme.Https})
type
  Call_JobKill_564124 = ref object of OpenApiRestCall_563556
proc url_JobKill_564126(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobKill_564125(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564127 = path.getOrDefault("jobId")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "jobId", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   user.name: JString (required)
  ##            : The user name used for running job.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `user.name` field"
  var valid_564128 = query.getOrDefault("user.name")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "user.name", valid_564128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564129: Call_JobKill_564124; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates cancel on given running job in the specified HDInsight.
  ## 
  let valid = call_564129.validator(path, query, header, formData, body)
  let scheme = call_564129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564129.url(scheme.get, call_564129.host, call_564129.base,
                         call_564129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564129, url, valid)

proc call*(call_564130: Call_JobKill_564124; jobId: string; userName: string): Recallable =
  ## jobKill
  ## Initiates cancel on given running job in the specified HDInsight.
  ##   jobId: string (required)
  ##        : The id of the job.
  ##   userName: string (required)
  ##           : The user name used for running job.
  var path_564131 = newJObject()
  var query_564132 = newJObject()
  add(path_564131, "jobId", newJString(jobId))
  add(query_564132, "user.name", newJString(userName))
  result = call_564130.call(path_564131, query_564132, nil, nil, nil)

var jobKill* = Call_JobKill_564124(name: "jobKill", meth: HttpMethod.HttpDelete,
                                host: "azure.local",
                                route: "/templeton/v1/jobs/{jobId}",
                                validator: validate_JobKill_564125, base: "",
                                url: url_JobKill_564126, schemes: {Scheme.Https})
type
  Call_JobListAfterJobId_564133 = ref object of OpenApiRestCall_563556
proc url_JobListAfterJobId_564135(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobListAfterJobId_564134(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets numrecords Of Jobs after jobid from the specified HDInsight cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   user.name: JString (required)
  ##            : The user name used for running job.
  ##   numrecords: JInt
  ##             : Number of jobs to fetch.
  ##   showall: JString (required)
  ##          : If showall is set to 'true', the request will return all jobs the user has permission to view, not only the jobs belonging to the user.
  ##   fields: JString (required)
  ##         : If fields set to '*', the request will return full details of the job. Currently the value can only be '*'.
  ##   jobid: JString
  ##        : JobId from where to list jobs.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `user.name` field"
  var valid_564136 = query.getOrDefault("user.name")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "user.name", valid_564136
  var valid_564137 = query.getOrDefault("numrecords")
  valid_564137 = validateParameter(valid_564137, JInt, required = false, default = nil)
  if valid_564137 != nil:
    section.add "numrecords", valid_564137
  var valid_564138 = query.getOrDefault("showall")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = newJString("true"))
  if valid_564138 != nil:
    section.add "showall", valid_564138
  var valid_564139 = query.getOrDefault("fields")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = newJString("*"))
  if valid_564139 != nil:
    section.add "fields", valid_564139
  var valid_564140 = query.getOrDefault("jobid")
  valid_564140 = validateParameter(valid_564140, JString, required = false,
                                 default = nil)
  if valid_564140 != nil:
    section.add "jobid", valid_564140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564141: Call_JobListAfterJobId_564133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets numrecords Of Jobs after jobid from the specified HDInsight cluster.
  ## 
  let valid = call_564141.validator(path, query, header, formData, body)
  let scheme = call_564141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564141.url(scheme.get, call_564141.host, call_564141.base,
                         call_564141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564141, url, valid)

proc call*(call_564142: Call_JobListAfterJobId_564133; userName: string;
          numrecords: int = 0; showall: string = "true"; fields: string = "*";
          jobid: string = ""): Recallable =
  ## jobListAfterJobId
  ## Gets numrecords Of Jobs after jobid from the specified HDInsight cluster.
  ##   userName: string (required)
  ##           : The user name used for running job.
  ##   numrecords: int
  ##             : Number of jobs to fetch.
  ##   showall: string (required)
  ##          : If showall is set to 'true', the request will return all jobs the user has permission to view, not only the jobs belonging to the user.
  ##   fields: string (required)
  ##         : If fields set to '*', the request will return full details of the job. Currently the value can only be '*'.
  ##   jobid: string
  ##        : JobId from where to list jobs.
  var query_564143 = newJObject()
  add(query_564143, "user.name", newJString(userName))
  add(query_564143, "numrecords", newJInt(numrecords))
  add(query_564143, "showall", newJString(showall))
  add(query_564143, "fields", newJString(fields))
  add(query_564143, "jobid", newJString(jobid))
  result = call_564142.call(nil, query_564143, nil, nil, nil)

var jobListAfterJobId* = Call_JobListAfterJobId_564133(name: "jobListAfterJobId",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/templeton/v1/jobs?op=LISTAFTERID",
    validator: validate_JobListAfterJobId_564134, base: "",
    url: url_JobListAfterJobId_564135, schemes: {Scheme.Https})
type
  Call_JobSubmitMapReduceJob_564144 = ref object of OpenApiRestCall_563556
proc url_JobSubmitMapReduceJob_564146(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobSubmitMapReduceJob_564145(path: JsonNode; query: JsonNode;
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
  var valid_564147 = query.getOrDefault("user.name")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "user.name", valid_564147
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

proc call*(call_564149: Call_JobSubmitMapReduceJob_564144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a MapReduce job to an HDInsight cluster.
  ## 
  let valid = call_564149.validator(path, query, header, formData, body)
  let scheme = call_564149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564149.url(scheme.get, call_564149.host, call_564149.base,
                         call_564149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564149, url, valid)

proc call*(call_564150: Call_JobSubmitMapReduceJob_564144; userName: string;
          content: JsonNode): Recallable =
  ## jobSubmitMapReduceJob
  ## Submits a MapReduce job to an HDInsight cluster.
  ##   userName: string (required)
  ##           : The user name used for running job.
  ##   content: JObject (required)
  ##          : The content of the MapReduce job request.
  var query_564151 = newJObject()
  var body_564152 = newJObject()
  add(query_564151, "user.name", newJString(userName))
  if content != nil:
    body_564152 = content
  result = call_564150.call(nil, query_564151, nil, nil, body_564152)

var jobSubmitMapReduceJob* = Call_JobSubmitMapReduceJob_564144(
    name: "jobSubmitMapReduceJob", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/templeton/v1/mapreduce/jar",
    validator: validate_JobSubmitMapReduceJob_564145, base: "",
    url: url_JobSubmitMapReduceJob_564146, schemes: {Scheme.Https})
type
  Call_JobSubmitMapReduceStreamingJob_564153 = ref object of OpenApiRestCall_563556
proc url_JobSubmitMapReduceStreamingJob_564155(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobSubmitMapReduceStreamingJob_564154(path: JsonNode;
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
  var valid_564156 = query.getOrDefault("user.name")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "user.name", valid_564156
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

proc call*(call_564158: Call_JobSubmitMapReduceStreamingJob_564153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a MapReduce streaming job to an HDInsight cluster.
  ## 
  let valid = call_564158.validator(path, query, header, formData, body)
  let scheme = call_564158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564158.url(scheme.get, call_564158.host, call_564158.base,
                         call_564158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564158, url, valid)

proc call*(call_564159: Call_JobSubmitMapReduceStreamingJob_564153;
          userName: string; content: JsonNode): Recallable =
  ## jobSubmitMapReduceStreamingJob
  ## Submits a MapReduce streaming job to an HDInsight cluster.
  ##   userName: string (required)
  ##           : The user name used for running job.
  ##   content: JObject (required)
  ##          : The content of the MapReduce job request.
  var query_564160 = newJObject()
  var body_564161 = newJObject()
  add(query_564160, "user.name", newJString(userName))
  if content != nil:
    body_564161 = content
  result = call_564159.call(nil, query_564160, nil, nil, body_564161)

var jobSubmitMapReduceStreamingJob* = Call_JobSubmitMapReduceStreamingJob_564153(
    name: "jobSubmitMapReduceStreamingJob", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/templeton/v1/mapreduce/streaming",
    validator: validate_JobSubmitMapReduceStreamingJob_564154, base: "",
    url: url_JobSubmitMapReduceStreamingJob_564155, schemes: {Scheme.Https})
type
  Call_JobSubmitPigJob_564162 = ref object of OpenApiRestCall_563556
proc url_JobSubmitPigJob_564164(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobSubmitPigJob_564163(path: JsonNode; query: JsonNode;
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
  var valid_564165 = query.getOrDefault("user.name")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "user.name", valid_564165
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

proc call*(call_564167: Call_JobSubmitPigJob_564162; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a Pig job to an HDInsight cluster.
  ## 
  let valid = call_564167.validator(path, query, header, formData, body)
  let scheme = call_564167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564167.url(scheme.get, call_564167.host, call_564167.base,
                         call_564167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564167, url, valid)

proc call*(call_564168: Call_JobSubmitPigJob_564162; userName: string;
          content: JsonNode): Recallable =
  ## jobSubmitPigJob
  ## Submits a Pig job to an HDInsight cluster.
  ##   userName: string (required)
  ##           : The user name used for running job.
  ##   content: JObject (required)
  ##          : The content of the Pig job request.
  var query_564169 = newJObject()
  var body_564170 = newJObject()
  add(query_564169, "user.name", newJString(userName))
  if content != nil:
    body_564170 = content
  result = call_564168.call(nil, query_564169, nil, nil, body_564170)

var jobSubmitPigJob* = Call_JobSubmitPigJob_564162(name: "jobSubmitPigJob",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/templeton/v1/pig",
    validator: validate_JobSubmitPigJob_564163, base: "", url: url_JobSubmitPigJob_564164,
    schemes: {Scheme.Https})
type
  Call_JobSubmitSqoopJob_564171 = ref object of OpenApiRestCall_563556
proc url_JobSubmitSqoopJob_564173(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobSubmitSqoopJob_564172(path: JsonNode; query: JsonNode;
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
  var valid_564174 = query.getOrDefault("user.name")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "user.name", valid_564174
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

proc call*(call_564176: Call_JobSubmitSqoopJob_564171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a Sqoop job to an HDInsight cluster.
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_JobSubmitSqoopJob_564171; userName: string;
          content: JsonNode): Recallable =
  ## jobSubmitSqoopJob
  ## Submits a Sqoop job to an HDInsight cluster.
  ##   userName: string (required)
  ##           : The user name used for running job.
  ##   content: JObject (required)
  ##          : The content of the Sqoop job request.
  var query_564178 = newJObject()
  var body_564179 = newJObject()
  add(query_564178, "user.name", newJString(userName))
  if content != nil:
    body_564179 = content
  result = call_564177.call(nil, query_564178, nil, nil, body_564179)

var jobSubmitSqoopJob* = Call_JobSubmitSqoopJob_564171(name: "jobSubmitSqoopJob",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/templeton/v1/sqoop",
    validator: validate_JobSubmitSqoopJob_564172, base: "",
    url: url_JobSubmitSqoopJob_564173, schemes: {Scheme.Https})
type
  Call_JobGetAppState_564180 = ref object of OpenApiRestCall_563556
proc url_JobGetAppState_564182(protocol: Scheme; host: string; base: string;
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

proc validate_JobGetAppState_564181(path: JsonNode; query: JsonNode;
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
  var valid_564183 = path.getOrDefault("appId")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "appId", valid_564183
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564184: Call_JobGetAppState_564180; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets application state from the specified HDInsight cluster.
  ## 
  let valid = call_564184.validator(path, query, header, formData, body)
  let scheme = call_564184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564184.url(scheme.get, call_564184.host, call_564184.base,
                         call_564184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564184, url, valid)

proc call*(call_564185: Call_JobGetAppState_564180; appId: string): Recallable =
  ## jobGetAppState
  ## Gets application state from the specified HDInsight cluster.
  ##   appId: string (required)
  ##        : The id of the job.
  var path_564186 = newJObject()
  add(path_564186, "appId", newJString(appId))
  result = call_564185.call(path_564186, nil, nil, nil, nil)

var jobGetAppState* = Call_JobGetAppState_564180(name: "jobGetAppState",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/ws/v1/cluster/apps/{appId}/state",
    validator: validate_JobGetAppState_564181, base: "", url: url_JobGetAppState_564182,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
