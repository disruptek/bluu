
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DataLakeAnalyticsJobManagementClient
## version: 2017-09-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Creates an Azure Data Lake Analytics job client.
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "datalake-analytics-job"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobBuild_567879 = ref object of OpenApiRestCall_567657
proc url_JobBuild_567881(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobBuild_567880(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Builds (compiles) the specified job in the specified Data Lake Analytics account for job correctness and validation.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568057 = query.getOrDefault("api-version")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "api-version", valid_568057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to build a job.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568081: Call_JobBuild_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Builds (compiles) the specified job in the specified Data Lake Analytics account for job correctness and validation.
  ## 
  let valid = call_568081.validator(path, query, header, formData, body)
  let scheme = call_568081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568081.url(scheme.get, call_568081.host, call_568081.base,
                         call_568081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568081, url, valid)

proc call*(call_568152: Call_JobBuild_567879; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## jobBuild
  ## Builds (compiles) the specified job in the specified Data Lake Analytics account for job correctness and validation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : The parameters to build a job.
  var query_568153 = newJObject()
  var body_568155 = newJObject()
  add(query_568153, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568155 = parameters
  result = call_568152.call(nil, query_568153, nil, nil, body_568155)

var jobBuild* = Call_JobBuild_567879(name: "jobBuild", meth: HttpMethod.HttpPost,
                                  host: "azure.local", route: "/buildJob",
                                  validator: validate_JobBuild_567880, base: "",
                                  url: url_JobBuild_567881,
                                  schemes: {Scheme.Https})
type
  Call_JobList_568194 = ref object of OpenApiRestCall_567657
proc url_JobList_568196(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobList_568195(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the jobs, if any, associated with the specified Data Lake Analytics account. The response includes a link to the next page of results, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568198 = query.getOrDefault("$orderby")
  valid_568198 = validateParameter(valid_568198, JString, required = false,
                                 default = nil)
  if valid_568198 != nil:
    section.add "$orderby", valid_568198
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568199 = query.getOrDefault("api-version")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "api-version", valid_568199
  var valid_568200 = query.getOrDefault("$top")
  valid_568200 = validateParameter(valid_568200, JInt, required = false, default = nil)
  if valid_568200 != nil:
    section.add "$top", valid_568200
  var valid_568201 = query.getOrDefault("$select")
  valid_568201 = validateParameter(valid_568201, JString, required = false,
                                 default = nil)
  if valid_568201 != nil:
    section.add "$select", valid_568201
  var valid_568202 = query.getOrDefault("$skip")
  valid_568202 = validateParameter(valid_568202, JInt, required = false, default = nil)
  if valid_568202 != nil:
    section.add "$skip", valid_568202
  var valid_568203 = query.getOrDefault("$count")
  valid_568203 = validateParameter(valid_568203, JBool, required = false, default = nil)
  if valid_568203 != nil:
    section.add "$count", valid_568203
  var valid_568204 = query.getOrDefault("$filter")
  valid_568204 = validateParameter(valid_568204, JString, required = false,
                                 default = nil)
  if valid_568204 != nil:
    section.add "$filter", valid_568204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568205: Call_JobList_568194; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the jobs, if any, associated with the specified Data Lake Analytics account. The response includes a link to the next page of results, if any.
  ## 
  let valid = call_568205.validator(path, query, header, formData, body)
  let scheme = call_568205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568205.url(scheme.get, call_568205.host, call_568205.base,
                         call_568205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568205, url, valid)

proc call*(call_568206: Call_JobList_568194; apiVersion: string;
          Orderby: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## jobList
  ## Lists the jobs, if any, associated with the specified Data Lake Analytics account. The response includes a link to the next page of results, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var query_568207 = newJObject()
  add(query_568207, "$orderby", newJString(Orderby))
  add(query_568207, "api-version", newJString(apiVersion))
  add(query_568207, "$top", newJInt(Top))
  add(query_568207, "$select", newJString(Select))
  add(query_568207, "$skip", newJInt(Skip))
  add(query_568207, "$count", newJBool(Count))
  add(query_568207, "$filter", newJString(Filter))
  result = call_568206.call(nil, query_568207, nil, nil, nil)

var jobList* = Call_JobList_568194(name: "jobList", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/jobs",
                                validator: validate_JobList_568195, base: "",
                                url: url_JobList_568196, schemes: {Scheme.Https})
type
  Call_JobCreate_568231 = ref object of OpenApiRestCall_567657
proc url_JobCreate_568233(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobIdentity" in path, "`jobIdentity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobIdentity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCreate_568232(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Submits a job to the specified Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobIdentity: JString (required)
  ##              : Job identifier. Uniquely identifies the job across all jobs submitted to the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobIdentity` field"
  var valid_568244 = path.getOrDefault("jobIdentity")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "jobIdentity", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "api-version", valid_568245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to submit a job.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568247: Call_JobCreate_568231; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a job to the specified Data Lake Analytics account.
  ## 
  let valid = call_568247.validator(path, query, header, formData, body)
  let scheme = call_568247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568247.url(scheme.get, call_568247.host, call_568247.base,
                         call_568247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568247, url, valid)

proc call*(call_568248: Call_JobCreate_568231; apiVersion: string;
          jobIdentity: string; parameters: JsonNode): Recallable =
  ## jobCreate
  ## Submits a job to the specified Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : Job identifier. Uniquely identifies the job across all jobs submitted to the service.
  ##   parameters: JObject (required)
  ##             : The parameters to submit a job.
  var path_568249 = newJObject()
  var query_568250 = newJObject()
  var body_568251 = newJObject()
  add(query_568250, "api-version", newJString(apiVersion))
  add(path_568249, "jobIdentity", newJString(jobIdentity))
  if parameters != nil:
    body_568251 = parameters
  result = call_568248.call(path_568249, query_568250, nil, nil, body_568251)

var jobCreate* = Call_JobCreate_568231(name: "jobCreate", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/jobs/{jobIdentity}",
                                    validator: validate_JobCreate_568232,
                                    base: "", url: url_JobCreate_568233,
                                    schemes: {Scheme.Https})
type
  Call_JobGet_568208 = ref object of OpenApiRestCall_567657
proc url_JobGet_568210(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobIdentity" in path, "`jobIdentity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobIdentity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobGet_568209(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the job information for the specified job ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobIdentity: JString (required)
  ##              : JobInfo ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobIdentity` field"
  var valid_568225 = path.getOrDefault("jobIdentity")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "jobIdentity", valid_568225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568226 = query.getOrDefault("api-version")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "api-version", valid_568226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568227: Call_JobGet_568208; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the job information for the specified job ID.
  ## 
  let valid = call_568227.validator(path, query, header, formData, body)
  let scheme = call_568227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568227.url(scheme.get, call_568227.host, call_568227.base,
                         call_568227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568227, url, valid)

proc call*(call_568228: Call_JobGet_568208; apiVersion: string; jobIdentity: string): Recallable =
  ## jobGet
  ## Gets the job information for the specified job ID.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : JobInfo ID.
  var path_568229 = newJObject()
  var query_568230 = newJObject()
  add(query_568230, "api-version", newJString(apiVersion))
  add(path_568229, "jobIdentity", newJString(jobIdentity))
  result = call_568228.call(path_568229, query_568230, nil, nil, nil)

var jobGet* = Call_JobGet_568208(name: "jobGet", meth: HttpMethod.HttpGet,
                              host: "azure.local", route: "/jobs/{jobIdentity}",
                              validator: validate_JobGet_568209, base: "",
                              url: url_JobGet_568210, schemes: {Scheme.Https})
type
  Call_JobUpdate_568252 = ref object of OpenApiRestCall_567657
proc url_JobUpdate_568254(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobIdentity" in path, "`jobIdentity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobIdentity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobUpdate_568253(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the job information for the specified job ID. (Only for use internally with Scope job type.)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobIdentity: JString (required)
  ##              : Job identifier. Uniquely identifies the job across all jobs submitted to the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobIdentity` field"
  var valid_568255 = path.getOrDefault("jobIdentity")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "jobIdentity", valid_568255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568256 = query.getOrDefault("api-version")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "api-version", valid_568256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : The parameters to update a job.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568258: Call_JobUpdate_568252; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the job information for the specified job ID. (Only for use internally with Scope job type.)
  ## 
  let valid = call_568258.validator(path, query, header, formData, body)
  let scheme = call_568258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568258.url(scheme.get, call_568258.host, call_568258.base,
                         call_568258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568258, url, valid)

proc call*(call_568259: Call_JobUpdate_568252; apiVersion: string;
          jobIdentity: string; parameters: JsonNode = nil): Recallable =
  ## jobUpdate
  ## Updates the job information for the specified job ID. (Only for use internally with Scope job type.)
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : Job identifier. Uniquely identifies the job across all jobs submitted to the service.
  ##   parameters: JObject
  ##             : The parameters to update a job.
  var path_568260 = newJObject()
  var query_568261 = newJObject()
  var body_568262 = newJObject()
  add(query_568261, "api-version", newJString(apiVersion))
  add(path_568260, "jobIdentity", newJString(jobIdentity))
  if parameters != nil:
    body_568262 = parameters
  result = call_568259.call(path_568260, query_568261, nil, nil, body_568262)

var jobUpdate* = Call_JobUpdate_568252(name: "jobUpdate", meth: HttpMethod.HttpPatch,
                                    host: "azure.local",
                                    route: "/jobs/{jobIdentity}",
                                    validator: validate_JobUpdate_568253,
                                    base: "", url: url_JobUpdate_568254,
                                    schemes: {Scheme.Https})
type
  Call_JobCancel_568263 = ref object of OpenApiRestCall_567657
proc url_JobCancel_568265(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobIdentity" in path, "`jobIdentity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobIdentity"),
               (kind: ConstantSegment, value: "/CancelJob")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCancel_568264(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the running job specified by the job ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobIdentity: JString (required)
  ##              : Job identifier. Uniquely identifies the job across all jobs submitted to the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobIdentity` field"
  var valid_568266 = path.getOrDefault("jobIdentity")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "jobIdentity", valid_568266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568267 = query.getOrDefault("api-version")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "api-version", valid_568267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568268: Call_JobCancel_568263; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the running job specified by the job ID.
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_JobCancel_568263; apiVersion: string;
          jobIdentity: string): Recallable =
  ## jobCancel
  ## Cancels the running job specified by the job ID.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : Job identifier. Uniquely identifies the job across all jobs submitted to the service.
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "jobIdentity", newJString(jobIdentity))
  result = call_568269.call(path_568270, query_568271, nil, nil, nil)

var jobCancel* = Call_JobCancel_568263(name: "jobCancel", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/jobs/{jobIdentity}/CancelJob",
                                    validator: validate_JobCancel_568264,
                                    base: "", url: url_JobCancel_568265,
                                    schemes: {Scheme.Https})
type
  Call_JobGetDebugDataPath_568272 = ref object of OpenApiRestCall_567657
proc url_JobGetDebugDataPath_568274(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobIdentity" in path, "`jobIdentity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobIdentity"),
               (kind: ConstantSegment, value: "/GetDebugDataPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobGetDebugDataPath_568273(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the job debug data information specified by the job ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobIdentity: JString (required)
  ##              : Job identifier. Uniquely identifies the job across all jobs submitted to the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobIdentity` field"
  var valid_568275 = path.getOrDefault("jobIdentity")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "jobIdentity", valid_568275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568276 = query.getOrDefault("api-version")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "api-version", valid_568276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568277: Call_JobGetDebugDataPath_568272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the job debug data information specified by the job ID.
  ## 
  let valid = call_568277.validator(path, query, header, formData, body)
  let scheme = call_568277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568277.url(scheme.get, call_568277.host, call_568277.base,
                         call_568277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568277, url, valid)

proc call*(call_568278: Call_JobGetDebugDataPath_568272; apiVersion: string;
          jobIdentity: string): Recallable =
  ## jobGetDebugDataPath
  ## Gets the job debug data information specified by the job ID.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : Job identifier. Uniquely identifies the job across all jobs submitted to the service.
  var path_568279 = newJObject()
  var query_568280 = newJObject()
  add(query_568280, "api-version", newJString(apiVersion))
  add(path_568279, "jobIdentity", newJString(jobIdentity))
  result = call_568278.call(path_568279, query_568280, nil, nil, nil)

var jobGetDebugDataPath* = Call_JobGetDebugDataPath_568272(
    name: "jobGetDebugDataPath", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobIdentity}/GetDebugDataPath",
    validator: validate_JobGetDebugDataPath_568273, base: "",
    url: url_JobGetDebugDataPath_568274, schemes: {Scheme.Https})
type
  Call_JobGetStatistics_568281 = ref object of OpenApiRestCall_567657
proc url_JobGetStatistics_568283(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobIdentity" in path, "`jobIdentity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobIdentity"),
               (kind: ConstantSegment, value: "/GetStatistics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobGetStatistics_568282(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets statistics of the specified job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobIdentity: JString (required)
  ##              : Job Information ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobIdentity` field"
  var valid_568284 = path.getOrDefault("jobIdentity")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "jobIdentity", valid_568284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568285 = query.getOrDefault("api-version")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "api-version", valid_568285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568286: Call_JobGetStatistics_568281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets statistics of the specified job.
  ## 
  let valid = call_568286.validator(path, query, header, formData, body)
  let scheme = call_568286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568286.url(scheme.get, call_568286.host, call_568286.base,
                         call_568286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568286, url, valid)

proc call*(call_568287: Call_JobGetStatistics_568281; apiVersion: string;
          jobIdentity: string): Recallable =
  ## jobGetStatistics
  ## Gets statistics of the specified job.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : Job Information ID.
  var path_568288 = newJObject()
  var query_568289 = newJObject()
  add(query_568289, "api-version", newJString(apiVersion))
  add(path_568288, "jobIdentity", newJString(jobIdentity))
  result = call_568287.call(path_568288, query_568289, nil, nil, nil)

var jobGetStatistics* = Call_JobGetStatistics_568281(name: "jobGetStatistics",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobIdentity}/GetStatistics",
    validator: validate_JobGetStatistics_568282, base: "",
    url: url_JobGetStatistics_568283, schemes: {Scheme.Https})
type
  Call_JobYield_568290 = ref object of OpenApiRestCall_567657
proc url_JobYield_568292(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobIdentity" in path, "`jobIdentity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobIdentity"),
               (kind: ConstantSegment, value: "/YieldJob")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobYield_568291(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Pauses the specified job and places it back in the job queue, behind other jobs of equal or higher importance, based on priority. (Only for use internally with Scope job type.)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobIdentity: JString (required)
  ##              : Job identifier. Uniquely identifies the job across all jobs submitted to the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobIdentity` field"
  var valid_568293 = path.getOrDefault("jobIdentity")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "jobIdentity", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568295: Call_JobYield_568290; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pauses the specified job and places it back in the job queue, behind other jobs of equal or higher importance, based on priority. (Only for use internally with Scope job type.)
  ## 
  let valid = call_568295.validator(path, query, header, formData, body)
  let scheme = call_568295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568295.url(scheme.get, call_568295.host, call_568295.base,
                         call_568295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568295, url, valid)

proc call*(call_568296: Call_JobYield_568290; apiVersion: string; jobIdentity: string): Recallable =
  ## jobYield
  ## Pauses the specified job and places it back in the job queue, behind other jobs of equal or higher importance, based on priority. (Only for use internally with Scope job type.)
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : Job identifier. Uniquely identifies the job across all jobs submitted to the service.
  var path_568297 = newJObject()
  var query_568298 = newJObject()
  add(query_568298, "api-version", newJString(apiVersion))
  add(path_568297, "jobIdentity", newJString(jobIdentity))
  result = call_568296.call(path_568297, query_568298, nil, nil, nil)

var jobYield* = Call_JobYield_568290(name: "jobYield", meth: HttpMethod.HttpPost,
                                  host: "azure.local",
                                  route: "/jobs/{jobIdentity}/YieldJob",
                                  validator: validate_JobYield_568291, base: "",
                                  url: url_JobYield_568292,
                                  schemes: {Scheme.Https})
type
  Call_PipelineList_568299 = ref object of OpenApiRestCall_567657
proc url_PipelineList_568301(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PipelineList_568300(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all pipelines.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   startDateTime: JString
  ##                : The start date for when to get the list of pipelines. The startDateTime and endDateTime can be no more than 30 days apart.
  ##   endDateTime: JString
  ##              : The end date for when to get the list of pipelines. The startDateTime and endDateTime can be no more than 30 days apart.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568302 = query.getOrDefault("api-version")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "api-version", valid_568302
  var valid_568303 = query.getOrDefault("startDateTime")
  valid_568303 = validateParameter(valid_568303, JString, required = false,
                                 default = nil)
  if valid_568303 != nil:
    section.add "startDateTime", valid_568303
  var valid_568304 = query.getOrDefault("endDateTime")
  valid_568304 = validateParameter(valid_568304, JString, required = false,
                                 default = nil)
  if valid_568304 != nil:
    section.add "endDateTime", valid_568304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568305: Call_PipelineList_568299; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all pipelines.
  ## 
  let valid = call_568305.validator(path, query, header, formData, body)
  let scheme = call_568305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568305.url(scheme.get, call_568305.host, call_568305.base,
                         call_568305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568305, url, valid)

proc call*(call_568306: Call_PipelineList_568299; apiVersion: string;
          startDateTime: string = ""; endDateTime: string = ""): Recallable =
  ## pipelineList
  ## Lists all pipelines.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   startDateTime: string
  ##                : The start date for when to get the list of pipelines. The startDateTime and endDateTime can be no more than 30 days apart.
  ##   endDateTime: string
  ##              : The end date for when to get the list of pipelines. The startDateTime and endDateTime can be no more than 30 days apart.
  var query_568307 = newJObject()
  add(query_568307, "api-version", newJString(apiVersion))
  add(query_568307, "startDateTime", newJString(startDateTime))
  add(query_568307, "endDateTime", newJString(endDateTime))
  result = call_568306.call(nil, query_568307, nil, nil, nil)

var pipelineList* = Call_PipelineList_568299(name: "pipelineList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/pipelines",
    validator: validate_PipelineList_568300, base: "", url: url_PipelineList_568301,
    schemes: {Scheme.Https})
type
  Call_PipelineGet_568308 = ref object of OpenApiRestCall_567657
proc url_PipelineGet_568310(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "pipelineIdentity" in path,
        "`pipelineIdentity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pipelines/"),
               (kind: VariableSegment, value: "pipelineIdentity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelineGet_568309(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Pipeline information for the specified pipeline ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pipelineIdentity: JString (required)
  ##                   : Pipeline ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `pipelineIdentity` field"
  var valid_568311 = path.getOrDefault("pipelineIdentity")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "pipelineIdentity", valid_568311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   startDateTime: JString
  ##                : The start date for when to get the pipeline and aggregate its data. The startDateTime and endDateTime can be no more than 30 days apart.
  ##   endDateTime: JString
  ##              : The end date for when to get the pipeline and aggregate its data. The startDateTime and endDateTime can be no more than 30 days apart.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568312 = query.getOrDefault("api-version")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "api-version", valid_568312
  var valid_568313 = query.getOrDefault("startDateTime")
  valid_568313 = validateParameter(valid_568313, JString, required = false,
                                 default = nil)
  if valid_568313 != nil:
    section.add "startDateTime", valid_568313
  var valid_568314 = query.getOrDefault("endDateTime")
  valid_568314 = validateParameter(valid_568314, JString, required = false,
                                 default = nil)
  if valid_568314 != nil:
    section.add "endDateTime", valid_568314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568315: Call_PipelineGet_568308; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Pipeline information for the specified pipeline ID.
  ## 
  let valid = call_568315.validator(path, query, header, formData, body)
  let scheme = call_568315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568315.url(scheme.get, call_568315.host, call_568315.base,
                         call_568315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568315, url, valid)

proc call*(call_568316: Call_PipelineGet_568308; pipelineIdentity: string;
          apiVersion: string; startDateTime: string = ""; endDateTime: string = ""): Recallable =
  ## pipelineGet
  ## Gets the Pipeline information for the specified pipeline ID.
  ##   pipelineIdentity: string (required)
  ##                   : Pipeline ID.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   startDateTime: string
  ##                : The start date for when to get the pipeline and aggregate its data. The startDateTime and endDateTime can be no more than 30 days apart.
  ##   endDateTime: string
  ##              : The end date for when to get the pipeline and aggregate its data. The startDateTime and endDateTime can be no more than 30 days apart.
  var path_568317 = newJObject()
  var query_568318 = newJObject()
  add(path_568317, "pipelineIdentity", newJString(pipelineIdentity))
  add(query_568318, "api-version", newJString(apiVersion))
  add(query_568318, "startDateTime", newJString(startDateTime))
  add(query_568318, "endDateTime", newJString(endDateTime))
  result = call_568316.call(path_568317, query_568318, nil, nil, nil)

var pipelineGet* = Call_PipelineGet_568308(name: "pipelineGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/pipelines/{pipelineIdentity}",
                                        validator: validate_PipelineGet_568309,
                                        base: "", url: url_PipelineGet_568310,
                                        schemes: {Scheme.Https})
type
  Call_RecurrenceList_568319 = ref object of OpenApiRestCall_567657
proc url_RecurrenceList_568321(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecurrenceList_568320(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all recurrences.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   startDateTime: JString
  ##                : The start date for when to get the list of recurrences. The startDateTime and endDateTime can be no more than 30 days apart.
  ##   endDateTime: JString
  ##              : The end date for when to get the list of recurrences. The startDateTime and endDateTime can be no more than 30 days apart.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568322 = query.getOrDefault("api-version")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "api-version", valid_568322
  var valid_568323 = query.getOrDefault("startDateTime")
  valid_568323 = validateParameter(valid_568323, JString, required = false,
                                 default = nil)
  if valid_568323 != nil:
    section.add "startDateTime", valid_568323
  var valid_568324 = query.getOrDefault("endDateTime")
  valid_568324 = validateParameter(valid_568324, JString, required = false,
                                 default = nil)
  if valid_568324 != nil:
    section.add "endDateTime", valid_568324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568325: Call_RecurrenceList_568319; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all recurrences.
  ## 
  let valid = call_568325.validator(path, query, header, formData, body)
  let scheme = call_568325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568325.url(scheme.get, call_568325.host, call_568325.base,
                         call_568325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568325, url, valid)

proc call*(call_568326: Call_RecurrenceList_568319; apiVersion: string;
          startDateTime: string = ""; endDateTime: string = ""): Recallable =
  ## recurrenceList
  ## Lists all recurrences.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   startDateTime: string
  ##                : The start date for when to get the list of recurrences. The startDateTime and endDateTime can be no more than 30 days apart.
  ##   endDateTime: string
  ##              : The end date for when to get the list of recurrences. The startDateTime and endDateTime can be no more than 30 days apart.
  var query_568327 = newJObject()
  add(query_568327, "api-version", newJString(apiVersion))
  add(query_568327, "startDateTime", newJString(startDateTime))
  add(query_568327, "endDateTime", newJString(endDateTime))
  result = call_568326.call(nil, query_568327, nil, nil, nil)

var recurrenceList* = Call_RecurrenceList_568319(name: "recurrenceList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/recurrences",
    validator: validate_RecurrenceList_568320, base: "", url: url_RecurrenceList_568321,
    schemes: {Scheme.Https})
type
  Call_RecurrenceGet_568328 = ref object of OpenApiRestCall_567657
proc url_RecurrenceGet_568330(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "recurrenceIdentity" in path,
        "`recurrenceIdentity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/recurrences/"),
               (kind: VariableSegment, value: "recurrenceIdentity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecurrenceGet_568329(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the recurrence information for the specified recurrence ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   recurrenceIdentity: JString (required)
  ##                     : Recurrence ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `recurrenceIdentity` field"
  var valid_568331 = path.getOrDefault("recurrenceIdentity")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "recurrenceIdentity", valid_568331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   startDateTime: JString
  ##                : The start date for when to get the recurrence and aggregate its data. The startDateTime and endDateTime can be no more than 30 days apart.
  ##   endDateTime: JString
  ##              : The end date for when to get recurrence and aggregate its data. The startDateTime and endDateTime can be no more than 30 days apart.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568332 = query.getOrDefault("api-version")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "api-version", valid_568332
  var valid_568333 = query.getOrDefault("startDateTime")
  valid_568333 = validateParameter(valid_568333, JString, required = false,
                                 default = nil)
  if valid_568333 != nil:
    section.add "startDateTime", valid_568333
  var valid_568334 = query.getOrDefault("endDateTime")
  valid_568334 = validateParameter(valid_568334, JString, required = false,
                                 default = nil)
  if valid_568334 != nil:
    section.add "endDateTime", valid_568334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568335: Call_RecurrenceGet_568328; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the recurrence information for the specified recurrence ID.
  ## 
  let valid = call_568335.validator(path, query, header, formData, body)
  let scheme = call_568335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568335.url(scheme.get, call_568335.host, call_568335.base,
                         call_568335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568335, url, valid)

proc call*(call_568336: Call_RecurrenceGet_568328; apiVersion: string;
          recurrenceIdentity: string; startDateTime: string = "";
          endDateTime: string = ""): Recallable =
  ## recurrenceGet
  ## Gets the recurrence information for the specified recurrence ID.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   startDateTime: string
  ##                : The start date for when to get the recurrence and aggregate its data. The startDateTime and endDateTime can be no more than 30 days apart.
  ##   recurrenceIdentity: string (required)
  ##                     : Recurrence ID.
  ##   endDateTime: string
  ##              : The end date for when to get recurrence and aggregate its data. The startDateTime and endDateTime can be no more than 30 days apart.
  var path_568337 = newJObject()
  var query_568338 = newJObject()
  add(query_568338, "api-version", newJString(apiVersion))
  add(query_568338, "startDateTime", newJString(startDateTime))
  add(path_568337, "recurrenceIdentity", newJString(recurrenceIdentity))
  add(query_568338, "endDateTime", newJString(endDateTime))
  result = call_568336.call(path_568337, query_568338, nil, nil, nil)

var recurrenceGet* = Call_RecurrenceGet_568328(name: "recurrenceGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/recurrences/{recurrenceIdentity}", validator: validate_RecurrenceGet_568329,
    base: "", url: url_RecurrenceGet_568330, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
