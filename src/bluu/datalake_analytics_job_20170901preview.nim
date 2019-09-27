
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  Call_JobBuild_593646 = ref object of OpenApiRestCall_593424
proc url_JobBuild_593648(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobBuild_593647(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593824 = query.getOrDefault("api-version")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "api-version", valid_593824
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

proc call*(call_593848: Call_JobBuild_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Builds (compiles) the specified job in the specified Data Lake Analytics account for job correctness and validation.
  ## 
  let valid = call_593848.validator(path, query, header, formData, body)
  let scheme = call_593848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593848.url(scheme.get, call_593848.host, call_593848.base,
                         call_593848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593848, url, valid)

proc call*(call_593919: Call_JobBuild_593646; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## jobBuild
  ## Builds (compiles) the specified job in the specified Data Lake Analytics account for job correctness and validation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : The parameters to build a job.
  var query_593920 = newJObject()
  var body_593922 = newJObject()
  add(query_593920, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_593922 = parameters
  result = call_593919.call(nil, query_593920, nil, nil, body_593922)

var jobBuild* = Call_JobBuild_593646(name: "jobBuild", meth: HttpMethod.HttpPost,
                                  host: "azure.local", route: "/buildJob",
                                  validator: validate_JobBuild_593647, base: "",
                                  url: url_JobBuild_593648,
                                  schemes: {Scheme.Https})
type
  Call_JobList_593961 = ref object of OpenApiRestCall_593424
proc url_JobList_593963(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobList_593962(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593965 = query.getOrDefault("$orderby")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "$orderby", valid_593965
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593966 = query.getOrDefault("api-version")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "api-version", valid_593966
  var valid_593967 = query.getOrDefault("$top")
  valid_593967 = validateParameter(valid_593967, JInt, required = false, default = nil)
  if valid_593967 != nil:
    section.add "$top", valid_593967
  var valid_593968 = query.getOrDefault("$select")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "$select", valid_593968
  var valid_593969 = query.getOrDefault("$skip")
  valid_593969 = validateParameter(valid_593969, JInt, required = false, default = nil)
  if valid_593969 != nil:
    section.add "$skip", valid_593969
  var valid_593970 = query.getOrDefault("$count")
  valid_593970 = validateParameter(valid_593970, JBool, required = false, default = nil)
  if valid_593970 != nil:
    section.add "$count", valid_593970
  var valid_593971 = query.getOrDefault("$filter")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "$filter", valid_593971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593972: Call_JobList_593961; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the jobs, if any, associated with the specified Data Lake Analytics account. The response includes a link to the next page of results, if any.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_JobList_593961; apiVersion: string;
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
  var query_593974 = newJObject()
  add(query_593974, "$orderby", newJString(Orderby))
  add(query_593974, "api-version", newJString(apiVersion))
  add(query_593974, "$top", newJInt(Top))
  add(query_593974, "$select", newJString(Select))
  add(query_593974, "$skip", newJInt(Skip))
  add(query_593974, "$count", newJBool(Count))
  add(query_593974, "$filter", newJString(Filter))
  result = call_593973.call(nil, query_593974, nil, nil, nil)

var jobList* = Call_JobList_593961(name: "jobList", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/jobs",
                                validator: validate_JobList_593962, base: "",
                                url: url_JobList_593963, schemes: {Scheme.Https})
type
  Call_JobCreate_593998 = ref object of OpenApiRestCall_593424
proc url_JobCreate_594000(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobCreate_593999(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594011 = path.getOrDefault("jobIdentity")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "jobIdentity", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594012 = query.getOrDefault("api-version")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "api-version", valid_594012
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

proc call*(call_594014: Call_JobCreate_593998; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a job to the specified Data Lake Analytics account.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_JobCreate_593998; apiVersion: string;
          jobIdentity: string; parameters: JsonNode): Recallable =
  ## jobCreate
  ## Submits a job to the specified Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : Job identifier. Uniquely identifies the job across all jobs submitted to the service.
  ##   parameters: JObject (required)
  ##             : The parameters to submit a job.
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  var body_594018 = newJObject()
  add(query_594017, "api-version", newJString(apiVersion))
  add(path_594016, "jobIdentity", newJString(jobIdentity))
  if parameters != nil:
    body_594018 = parameters
  result = call_594015.call(path_594016, query_594017, nil, nil, body_594018)

var jobCreate* = Call_JobCreate_593998(name: "jobCreate", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/jobs/{jobIdentity}",
                                    validator: validate_JobCreate_593999,
                                    base: "", url: url_JobCreate_594000,
                                    schemes: {Scheme.Https})
type
  Call_JobGet_593975 = ref object of OpenApiRestCall_593424
proc url_JobGet_593977(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobGet_593976(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593992 = path.getOrDefault("jobIdentity")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "jobIdentity", valid_593992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593993 = query.getOrDefault("api-version")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "api-version", valid_593993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593994: Call_JobGet_593975; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the job information for the specified job ID.
  ## 
  let valid = call_593994.validator(path, query, header, formData, body)
  let scheme = call_593994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593994.url(scheme.get, call_593994.host, call_593994.base,
                         call_593994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593994, url, valid)

proc call*(call_593995: Call_JobGet_593975; apiVersion: string; jobIdentity: string): Recallable =
  ## jobGet
  ## Gets the job information for the specified job ID.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : JobInfo ID.
  var path_593996 = newJObject()
  var query_593997 = newJObject()
  add(query_593997, "api-version", newJString(apiVersion))
  add(path_593996, "jobIdentity", newJString(jobIdentity))
  result = call_593995.call(path_593996, query_593997, nil, nil, nil)

var jobGet* = Call_JobGet_593975(name: "jobGet", meth: HttpMethod.HttpGet,
                              host: "azure.local", route: "/jobs/{jobIdentity}",
                              validator: validate_JobGet_593976, base: "",
                              url: url_JobGet_593977, schemes: {Scheme.Https})
type
  Call_JobUpdate_594019 = ref object of OpenApiRestCall_593424
proc url_JobUpdate_594021(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobUpdate_594020(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594022 = path.getOrDefault("jobIdentity")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "jobIdentity", valid_594022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594023 = query.getOrDefault("api-version")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "api-version", valid_594023
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

proc call*(call_594025: Call_JobUpdate_594019; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the job information for the specified job ID. (Only for use internally with Scope job type.)
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_JobUpdate_594019; apiVersion: string;
          jobIdentity: string; parameters: JsonNode = nil): Recallable =
  ## jobUpdate
  ## Updates the job information for the specified job ID. (Only for use internally with Scope job type.)
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : Job identifier. Uniquely identifies the job across all jobs submitted to the service.
  ##   parameters: JObject
  ##             : The parameters to update a job.
  var path_594027 = newJObject()
  var query_594028 = newJObject()
  var body_594029 = newJObject()
  add(query_594028, "api-version", newJString(apiVersion))
  add(path_594027, "jobIdentity", newJString(jobIdentity))
  if parameters != nil:
    body_594029 = parameters
  result = call_594026.call(path_594027, query_594028, nil, nil, body_594029)

var jobUpdate* = Call_JobUpdate_594019(name: "jobUpdate", meth: HttpMethod.HttpPatch,
                                    host: "azure.local",
                                    route: "/jobs/{jobIdentity}",
                                    validator: validate_JobUpdate_594020,
                                    base: "", url: url_JobUpdate_594021,
                                    schemes: {Scheme.Https})
type
  Call_JobCancel_594030 = ref object of OpenApiRestCall_593424
proc url_JobCancel_594032(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobCancel_594031(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594033 = path.getOrDefault("jobIdentity")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "jobIdentity", valid_594033
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594034 = query.getOrDefault("api-version")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "api-version", valid_594034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594035: Call_JobCancel_594030; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the running job specified by the job ID.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_JobCancel_594030; apiVersion: string;
          jobIdentity: string): Recallable =
  ## jobCancel
  ## Cancels the running job specified by the job ID.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : Job identifier. Uniquely identifies the job across all jobs submitted to the service.
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  add(query_594038, "api-version", newJString(apiVersion))
  add(path_594037, "jobIdentity", newJString(jobIdentity))
  result = call_594036.call(path_594037, query_594038, nil, nil, nil)

var jobCancel* = Call_JobCancel_594030(name: "jobCancel", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/jobs/{jobIdentity}/CancelJob",
                                    validator: validate_JobCancel_594031,
                                    base: "", url: url_JobCancel_594032,
                                    schemes: {Scheme.Https})
type
  Call_JobGetDebugDataPath_594039 = ref object of OpenApiRestCall_593424
proc url_JobGetDebugDataPath_594041(protocol: Scheme; host: string; base: string;
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

proc validate_JobGetDebugDataPath_594040(path: JsonNode; query: JsonNode;
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
  var valid_594042 = path.getOrDefault("jobIdentity")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "jobIdentity", valid_594042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594043 = query.getOrDefault("api-version")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "api-version", valid_594043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594044: Call_JobGetDebugDataPath_594039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the job debug data information specified by the job ID.
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_JobGetDebugDataPath_594039; apiVersion: string;
          jobIdentity: string): Recallable =
  ## jobGetDebugDataPath
  ## Gets the job debug data information specified by the job ID.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : Job identifier. Uniquely identifies the job across all jobs submitted to the service.
  var path_594046 = newJObject()
  var query_594047 = newJObject()
  add(query_594047, "api-version", newJString(apiVersion))
  add(path_594046, "jobIdentity", newJString(jobIdentity))
  result = call_594045.call(path_594046, query_594047, nil, nil, nil)

var jobGetDebugDataPath* = Call_JobGetDebugDataPath_594039(
    name: "jobGetDebugDataPath", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobIdentity}/GetDebugDataPath",
    validator: validate_JobGetDebugDataPath_594040, base: "",
    url: url_JobGetDebugDataPath_594041, schemes: {Scheme.Https})
type
  Call_JobGetStatistics_594048 = ref object of OpenApiRestCall_593424
proc url_JobGetStatistics_594050(protocol: Scheme; host: string; base: string;
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

proc validate_JobGetStatistics_594049(path: JsonNode; query: JsonNode;
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
  var valid_594051 = path.getOrDefault("jobIdentity")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "jobIdentity", valid_594051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594052 = query.getOrDefault("api-version")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "api-version", valid_594052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594053: Call_JobGetStatistics_594048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets statistics of the specified job.
  ## 
  let valid = call_594053.validator(path, query, header, formData, body)
  let scheme = call_594053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594053.url(scheme.get, call_594053.host, call_594053.base,
                         call_594053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594053, url, valid)

proc call*(call_594054: Call_JobGetStatistics_594048; apiVersion: string;
          jobIdentity: string): Recallable =
  ## jobGetStatistics
  ## Gets statistics of the specified job.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : Job Information ID.
  var path_594055 = newJObject()
  var query_594056 = newJObject()
  add(query_594056, "api-version", newJString(apiVersion))
  add(path_594055, "jobIdentity", newJString(jobIdentity))
  result = call_594054.call(path_594055, query_594056, nil, nil, nil)

var jobGetStatistics* = Call_JobGetStatistics_594048(name: "jobGetStatistics",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobIdentity}/GetStatistics",
    validator: validate_JobGetStatistics_594049, base: "",
    url: url_JobGetStatistics_594050, schemes: {Scheme.Https})
type
  Call_JobYield_594057 = ref object of OpenApiRestCall_593424
proc url_JobYield_594059(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobYield_594058(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594060 = path.getOrDefault("jobIdentity")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "jobIdentity", valid_594060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594061 = query.getOrDefault("api-version")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "api-version", valid_594061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594062: Call_JobYield_594057; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pauses the specified job and places it back in the job queue, behind other jobs of equal or higher importance, based on priority. (Only for use internally with Scope job type.)
  ## 
  let valid = call_594062.validator(path, query, header, formData, body)
  let scheme = call_594062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594062.url(scheme.get, call_594062.host, call_594062.base,
                         call_594062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594062, url, valid)

proc call*(call_594063: Call_JobYield_594057; apiVersion: string; jobIdentity: string): Recallable =
  ## jobYield
  ## Pauses the specified job and places it back in the job queue, behind other jobs of equal or higher importance, based on priority. (Only for use internally with Scope job type.)
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobIdentity: string (required)
  ##              : Job identifier. Uniquely identifies the job across all jobs submitted to the service.
  var path_594064 = newJObject()
  var query_594065 = newJObject()
  add(query_594065, "api-version", newJString(apiVersion))
  add(path_594064, "jobIdentity", newJString(jobIdentity))
  result = call_594063.call(path_594064, query_594065, nil, nil, nil)

var jobYield* = Call_JobYield_594057(name: "jobYield", meth: HttpMethod.HttpPost,
                                  host: "azure.local",
                                  route: "/jobs/{jobIdentity}/YieldJob",
                                  validator: validate_JobYield_594058, base: "",
                                  url: url_JobYield_594059,
                                  schemes: {Scheme.Https})
type
  Call_PipelineList_594066 = ref object of OpenApiRestCall_593424
proc url_PipelineList_594068(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PipelineList_594067(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594069 = query.getOrDefault("api-version")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "api-version", valid_594069
  var valid_594070 = query.getOrDefault("startDateTime")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "startDateTime", valid_594070
  var valid_594071 = query.getOrDefault("endDateTime")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "endDateTime", valid_594071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594072: Call_PipelineList_594066; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all pipelines.
  ## 
  let valid = call_594072.validator(path, query, header, formData, body)
  let scheme = call_594072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594072.url(scheme.get, call_594072.host, call_594072.base,
                         call_594072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594072, url, valid)

proc call*(call_594073: Call_PipelineList_594066; apiVersion: string;
          startDateTime: string = ""; endDateTime: string = ""): Recallable =
  ## pipelineList
  ## Lists all pipelines.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   startDateTime: string
  ##                : The start date for when to get the list of pipelines. The startDateTime and endDateTime can be no more than 30 days apart.
  ##   endDateTime: string
  ##              : The end date for when to get the list of pipelines. The startDateTime and endDateTime can be no more than 30 days apart.
  var query_594074 = newJObject()
  add(query_594074, "api-version", newJString(apiVersion))
  add(query_594074, "startDateTime", newJString(startDateTime))
  add(query_594074, "endDateTime", newJString(endDateTime))
  result = call_594073.call(nil, query_594074, nil, nil, nil)

var pipelineList* = Call_PipelineList_594066(name: "pipelineList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/pipelines",
    validator: validate_PipelineList_594067, base: "", url: url_PipelineList_594068,
    schemes: {Scheme.Https})
type
  Call_PipelineGet_594075 = ref object of OpenApiRestCall_593424
proc url_PipelineGet_594077(protocol: Scheme; host: string; base: string;
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

proc validate_PipelineGet_594076(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594078 = path.getOrDefault("pipelineIdentity")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "pipelineIdentity", valid_594078
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
  var valid_594079 = query.getOrDefault("api-version")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "api-version", valid_594079
  var valid_594080 = query.getOrDefault("startDateTime")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "startDateTime", valid_594080
  var valid_594081 = query.getOrDefault("endDateTime")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "endDateTime", valid_594081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594082: Call_PipelineGet_594075; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Pipeline information for the specified pipeline ID.
  ## 
  let valid = call_594082.validator(path, query, header, formData, body)
  let scheme = call_594082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594082.url(scheme.get, call_594082.host, call_594082.base,
                         call_594082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594082, url, valid)

proc call*(call_594083: Call_PipelineGet_594075; pipelineIdentity: string;
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
  var path_594084 = newJObject()
  var query_594085 = newJObject()
  add(path_594084, "pipelineIdentity", newJString(pipelineIdentity))
  add(query_594085, "api-version", newJString(apiVersion))
  add(query_594085, "startDateTime", newJString(startDateTime))
  add(query_594085, "endDateTime", newJString(endDateTime))
  result = call_594083.call(path_594084, query_594085, nil, nil, nil)

var pipelineGet* = Call_PipelineGet_594075(name: "pipelineGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/pipelines/{pipelineIdentity}",
                                        validator: validate_PipelineGet_594076,
                                        base: "", url: url_PipelineGet_594077,
                                        schemes: {Scheme.Https})
type
  Call_RecurrenceList_594086 = ref object of OpenApiRestCall_593424
proc url_RecurrenceList_594088(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecurrenceList_594087(path: JsonNode; query: JsonNode;
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
  var valid_594089 = query.getOrDefault("api-version")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "api-version", valid_594089
  var valid_594090 = query.getOrDefault("startDateTime")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "startDateTime", valid_594090
  var valid_594091 = query.getOrDefault("endDateTime")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "endDateTime", valid_594091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594092: Call_RecurrenceList_594086; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all recurrences.
  ## 
  let valid = call_594092.validator(path, query, header, formData, body)
  let scheme = call_594092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594092.url(scheme.get, call_594092.host, call_594092.base,
                         call_594092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594092, url, valid)

proc call*(call_594093: Call_RecurrenceList_594086; apiVersion: string;
          startDateTime: string = ""; endDateTime: string = ""): Recallable =
  ## recurrenceList
  ## Lists all recurrences.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   startDateTime: string
  ##                : The start date for when to get the list of recurrences. The startDateTime and endDateTime can be no more than 30 days apart.
  ##   endDateTime: string
  ##              : The end date for when to get the list of recurrences. The startDateTime and endDateTime can be no more than 30 days apart.
  var query_594094 = newJObject()
  add(query_594094, "api-version", newJString(apiVersion))
  add(query_594094, "startDateTime", newJString(startDateTime))
  add(query_594094, "endDateTime", newJString(endDateTime))
  result = call_594093.call(nil, query_594094, nil, nil, nil)

var recurrenceList* = Call_RecurrenceList_594086(name: "recurrenceList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/recurrences",
    validator: validate_RecurrenceList_594087, base: "", url: url_RecurrenceList_594088,
    schemes: {Scheme.Https})
type
  Call_RecurrenceGet_594095 = ref object of OpenApiRestCall_593424
proc url_RecurrenceGet_594097(protocol: Scheme; host: string; base: string;
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

proc validate_RecurrenceGet_594096(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594098 = path.getOrDefault("recurrenceIdentity")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "recurrenceIdentity", valid_594098
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
  var valid_594099 = query.getOrDefault("api-version")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "api-version", valid_594099
  var valid_594100 = query.getOrDefault("startDateTime")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "startDateTime", valid_594100
  var valid_594101 = query.getOrDefault("endDateTime")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "endDateTime", valid_594101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594102: Call_RecurrenceGet_594095; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the recurrence information for the specified recurrence ID.
  ## 
  let valid = call_594102.validator(path, query, header, formData, body)
  let scheme = call_594102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594102.url(scheme.get, call_594102.host, call_594102.base,
                         call_594102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594102, url, valid)

proc call*(call_594103: Call_RecurrenceGet_594095; apiVersion: string;
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
  var path_594104 = newJObject()
  var query_594105 = newJObject()
  add(query_594105, "api-version", newJString(apiVersion))
  add(query_594105, "startDateTime", newJString(startDateTime))
  add(path_594104, "recurrenceIdentity", newJString(recurrenceIdentity))
  add(query_594105, "endDateTime", newJString(endDateTime))
  result = call_594103.call(path_594104, query_594105, nil, nil, nil)

var recurrenceGet* = Call_RecurrenceGet_594095(name: "recurrenceGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/recurrences/{recurrenceIdentity}", validator: validate_RecurrenceGet_594096,
    base: "", url: url_RecurrenceGet_594097, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
