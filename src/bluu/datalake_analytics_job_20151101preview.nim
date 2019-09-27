
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DataLakeAnalyticsJobManagementClient
## version: 2015-11-01-preview
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  macServiceName = "datalake-analytics-job"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobBuild_593630 = ref object of OpenApiRestCall_593408
proc url_JobBuild_593632(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobBuild_593631(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593808 = query.getOrDefault("api-version")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "api-version", valid_593808
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

proc call*(call_593832: Call_JobBuild_593630; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Builds (compiles) the specified job in the specified Data Lake Analytics account for job correctness and validation.
  ## 
  let valid = call_593832.validator(path, query, header, formData, body)
  let scheme = call_593832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593832.url(scheme.get, call_593832.host, call_593832.base,
                         call_593832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593832, url, valid)

proc call*(call_593903: Call_JobBuild_593630; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## jobBuild
  ## Builds (compiles) the specified job in the specified Data Lake Analytics account for job correctness and validation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : The parameters to build a job.
  var query_593904 = newJObject()
  var body_593906 = newJObject()
  add(query_593904, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_593906 = parameters
  result = call_593903.call(nil, query_593904, nil, nil, body_593906)

var jobBuild* = Call_JobBuild_593630(name: "jobBuild", meth: HttpMethod.HttpPost,
                                  host: "azure.local", route: "/BuildJob",
                                  validator: validate_JobBuild_593631, base: "",
                                  url: url_JobBuild_593632,
                                  schemes: {Scheme.Https})
type
  Call_JobList_593945 = ref object of OpenApiRestCall_593408
proc url_JobList_593947(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobList_593946(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
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
  ##   $search: JString
  ##          : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   $format: JString
  ##          : The return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_593949 = query.getOrDefault("$orderby")
  valid_593949 = validateParameter(valid_593949, JString, required = false,
                                 default = nil)
  if valid_593949 != nil:
    section.add "$orderby", valid_593949
  var valid_593950 = query.getOrDefault("$expand")
  valid_593950 = validateParameter(valid_593950, JString, required = false,
                                 default = nil)
  if valid_593950 != nil:
    section.add "$expand", valid_593950
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593951 = query.getOrDefault("api-version")
  valid_593951 = validateParameter(valid_593951, JString, required = true,
                                 default = nil)
  if valid_593951 != nil:
    section.add "api-version", valid_593951
  var valid_593952 = query.getOrDefault("$top")
  valid_593952 = validateParameter(valid_593952, JInt, required = false, default = nil)
  if valid_593952 != nil:
    section.add "$top", valid_593952
  var valid_593953 = query.getOrDefault("$select")
  valid_593953 = validateParameter(valid_593953, JString, required = false,
                                 default = nil)
  if valid_593953 != nil:
    section.add "$select", valid_593953
  var valid_593954 = query.getOrDefault("$skip")
  valid_593954 = validateParameter(valid_593954, JInt, required = false, default = nil)
  if valid_593954 != nil:
    section.add "$skip", valid_593954
  var valid_593955 = query.getOrDefault("$count")
  valid_593955 = validateParameter(valid_593955, JBool, required = false, default = nil)
  if valid_593955 != nil:
    section.add "$count", valid_593955
  var valid_593956 = query.getOrDefault("$search")
  valid_593956 = validateParameter(valid_593956, JString, required = false,
                                 default = nil)
  if valid_593956 != nil:
    section.add "$search", valid_593956
  var valid_593957 = query.getOrDefault("$format")
  valid_593957 = validateParameter(valid_593957, JString, required = false,
                                 default = nil)
  if valid_593957 != nil:
    section.add "$format", valid_593957
  var valid_593958 = query.getOrDefault("$filter")
  valid_593958 = validateParameter(valid_593958, JString, required = false,
                                 default = nil)
  if valid_593958 != nil:
    section.add "$filter", valid_593958
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593959: Call_JobList_593945; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the jobs, if any, associated with the specified Data Lake Analytics account. The response includes a link to the next page of results, if any.
  ## 
  let valid = call_593959.validator(path, query, header, formData, body)
  let scheme = call_593959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593959.url(scheme.get, call_593959.host, call_593959.base,
                         call_593959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593959, url, valid)

proc call*(call_593960: Call_JobList_593945; apiVersion: string;
          Orderby: string = ""; Expand: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Search: string = ""; Format: string = "";
          Filter: string = ""): Recallable =
  ## jobList
  ## Lists the jobs, if any, associated with the specified Data Lake Analytics account. The response includes a link to the next page of results, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
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
  ##   Search: string
  ##         : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   Format: string
  ##         : The return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var query_593961 = newJObject()
  add(query_593961, "$orderby", newJString(Orderby))
  add(query_593961, "$expand", newJString(Expand))
  add(query_593961, "api-version", newJString(apiVersion))
  add(query_593961, "$top", newJInt(Top))
  add(query_593961, "$select", newJString(Select))
  add(query_593961, "$skip", newJInt(Skip))
  add(query_593961, "$count", newJBool(Count))
  add(query_593961, "$search", newJString(Search))
  add(query_593961, "$format", newJString(Format))
  add(query_593961, "$filter", newJString(Filter))
  result = call_593960.call(nil, query_593961, nil, nil, nil)

var jobList* = Call_JobList_593945(name: "jobList", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/Jobs",
                                validator: validate_JobList_593946, base: "",
                                url: url_JobList_593947, schemes: {Scheme.Https})
type
  Call_JobCreate_593985 = ref object of OpenApiRestCall_593408
proc url_JobCreate_593987(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobIdentity" in path, "`jobIdentity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Jobs/"),
               (kind: VariableSegment, value: "jobIdentity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCreate_593986(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Submits a job to the specified Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobIdentity: JString (required)
  ##              : The job ID (a GUID) for the job being submitted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobIdentity` field"
  var valid_593988 = path.getOrDefault("jobIdentity")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "jobIdentity", valid_593988
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593989 = query.getOrDefault("api-version")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "api-version", valid_593989
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

proc call*(call_593991: Call_JobCreate_593985; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a job to the specified Data Lake Analytics account.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_JobCreate_593985; apiVersion: string;
          jobIdentity: string; parameters: JsonNode): Recallable =
  ## jobCreate
  ## Submits a job to the specified Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : The job ID (a GUID) for the job being submitted.
  ##   parameters: JObject (required)
  ##             : The parameters to submit a job.
  var path_593993 = newJObject()
  var query_593994 = newJObject()
  var body_593995 = newJObject()
  add(query_593994, "api-version", newJString(apiVersion))
  add(path_593993, "jobIdentity", newJString(jobIdentity))
  if parameters != nil:
    body_593995 = parameters
  result = call_593992.call(path_593993, query_593994, nil, nil, body_593995)

var jobCreate* = Call_JobCreate_593985(name: "jobCreate", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/Jobs/{jobIdentity}",
                                    validator: validate_JobCreate_593986,
                                    base: "", url: url_JobCreate_593987,
                                    schemes: {Scheme.Https})
type
  Call_JobGet_593962 = ref object of OpenApiRestCall_593408
proc url_JobGet_593964(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobIdentity" in path, "`jobIdentity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Jobs/"),
               (kind: VariableSegment, value: "jobIdentity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobGet_593963(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593979 = path.getOrDefault("jobIdentity")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "jobIdentity", valid_593979
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593980 = query.getOrDefault("api-version")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "api-version", valid_593980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593981: Call_JobGet_593962; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the job information for the specified job ID.
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_JobGet_593962; apiVersion: string; jobIdentity: string): Recallable =
  ## jobGet
  ## Gets the job information for the specified job ID.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : JobInfo ID.
  var path_593983 = newJObject()
  var query_593984 = newJObject()
  add(query_593984, "api-version", newJString(apiVersion))
  add(path_593983, "jobIdentity", newJString(jobIdentity))
  result = call_593982.call(path_593983, query_593984, nil, nil, nil)

var jobGet* = Call_JobGet_593962(name: "jobGet", meth: HttpMethod.HttpGet,
                              host: "azure.local", route: "/Jobs/{jobIdentity}",
                              validator: validate_JobGet_593963, base: "",
                              url: url_JobGet_593964, schemes: {Scheme.Https})
type
  Call_JobCancel_593996 = ref object of OpenApiRestCall_593408
proc url_JobCancel_593998(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobIdentity" in path, "`jobIdentity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Jobs/"),
               (kind: VariableSegment, value: "jobIdentity"),
               (kind: ConstantSegment, value: "/CancelJob")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCancel_593997(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the running job specified by the job ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobIdentity: JString (required)
  ##              : JobInfo ID to cancel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobIdentity` field"
  var valid_593999 = path.getOrDefault("jobIdentity")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "jobIdentity", valid_593999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594000 = query.getOrDefault("api-version")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "api-version", valid_594000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594001: Call_JobCancel_593996; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the running job specified by the job ID.
  ## 
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_JobCancel_593996; apiVersion: string;
          jobIdentity: string): Recallable =
  ## jobCancel
  ## Cancels the running job specified by the job ID.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : JobInfo ID to cancel.
  var path_594003 = newJObject()
  var query_594004 = newJObject()
  add(query_594004, "api-version", newJString(apiVersion))
  add(path_594003, "jobIdentity", newJString(jobIdentity))
  result = call_594002.call(path_594003, query_594004, nil, nil, nil)

var jobCancel* = Call_JobCancel_593996(name: "jobCancel", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/Jobs/{jobIdentity}/CancelJob",
                                    validator: validate_JobCancel_593997,
                                    base: "", url: url_JobCancel_593998,
                                    schemes: {Scheme.Https})
type
  Call_JobGetDebugDataPath_594005 = ref object of OpenApiRestCall_593408
proc url_JobGetDebugDataPath_594007(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobIdentity" in path, "`jobIdentity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Jobs/"),
               (kind: VariableSegment, value: "jobIdentity"),
               (kind: ConstantSegment, value: "/GetDebugDataPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobGetDebugDataPath_594006(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the U-SQL job debug data information specified by the job ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobIdentity: JString (required)
  ##              : JobInfo ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobIdentity` field"
  var valid_594008 = path.getOrDefault("jobIdentity")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "jobIdentity", valid_594008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594009 = query.getOrDefault("api-version")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "api-version", valid_594009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594010: Call_JobGetDebugDataPath_594005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the U-SQL job debug data information specified by the job ID.
  ## 
  let valid = call_594010.validator(path, query, header, formData, body)
  let scheme = call_594010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594010.url(scheme.get, call_594010.host, call_594010.base,
                         call_594010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594010, url, valid)

proc call*(call_594011: Call_JobGetDebugDataPath_594005; apiVersion: string;
          jobIdentity: string): Recallable =
  ## jobGetDebugDataPath
  ## Gets the U-SQL job debug data information specified by the job ID.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : JobInfo ID.
  var path_594012 = newJObject()
  var query_594013 = newJObject()
  add(query_594013, "api-version", newJString(apiVersion))
  add(path_594012, "jobIdentity", newJString(jobIdentity))
  result = call_594011.call(path_594012, query_594013, nil, nil, nil)

var jobGetDebugDataPath* = Call_JobGetDebugDataPath_594005(
    name: "jobGetDebugDataPath", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/Jobs/{jobIdentity}/GetDebugDataPath",
    validator: validate_JobGetDebugDataPath_594006, base: "",
    url: url_JobGetDebugDataPath_594007, schemes: {Scheme.Https})
type
  Call_JobGetStatistics_594014 = ref object of OpenApiRestCall_593408
proc url_JobGetStatistics_594016(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobIdentity" in path, "`jobIdentity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Jobs/"),
               (kind: VariableSegment, value: "jobIdentity"),
               (kind: ConstantSegment, value: "/GetStatistics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobGetStatistics_594015(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets statistics of the specified job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobIdentity: JString (required)
  ##              : JobInfo ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobIdentity` field"
  var valid_594017 = path.getOrDefault("jobIdentity")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "jobIdentity", valid_594017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594018 = query.getOrDefault("api-version")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "api-version", valid_594018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594019: Call_JobGetStatistics_594014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets statistics of the specified job.
  ## 
  let valid = call_594019.validator(path, query, header, formData, body)
  let scheme = call_594019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594019.url(scheme.get, call_594019.host, call_594019.base,
                         call_594019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594019, url, valid)

proc call*(call_594020: Call_JobGetStatistics_594014; apiVersion: string;
          jobIdentity: string): Recallable =
  ## jobGetStatistics
  ## Gets statistics of the specified job.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : JobInfo ID.
  var path_594021 = newJObject()
  var query_594022 = newJObject()
  add(query_594022, "api-version", newJString(apiVersion))
  add(path_594021, "jobIdentity", newJString(jobIdentity))
  result = call_594020.call(path_594021, query_594022, nil, nil, nil)

var jobGetStatistics* = Call_JobGetStatistics_594014(name: "jobGetStatistics",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/Jobs/{jobIdentity}/GetStatistics",
    validator: validate_JobGetStatistics_594015, base: "",
    url: url_JobGetStatistics_594016, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
