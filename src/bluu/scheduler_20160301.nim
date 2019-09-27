
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SchedulerManagementClient
## version: 2016-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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
  macServiceName = "scheduler"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobCollectionsListBySubscription_593646 = ref object of OpenApiRestCall_593424
proc url_JobCollectionsListBySubscription_593648(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Scheduler/jobCollections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCollectionsListBySubscription_593647(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all job collections under specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593821 = path.getOrDefault("subscriptionId")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "subscriptionId", valid_593821
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593822 = query.getOrDefault("api-version")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "api-version", valid_593822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_JobCollectionsListBySubscription_593646;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all job collections under specified subscription.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_JobCollectionsListBySubscription_593646;
          apiVersion: string; subscriptionId: string): Recallable =
  ## jobCollectionsListBySubscription
  ## Gets all job collections under specified subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_593917 = newJObject()
  var query_593919 = newJObject()
  add(query_593919, "api-version", newJString(apiVersion))
  add(path_593917, "subscriptionId", newJString(subscriptionId))
  result = call_593916.call(path_593917, query_593919, nil, nil, nil)

var jobCollectionsListBySubscription* = Call_JobCollectionsListBySubscription_593646(
    name: "jobCollectionsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Scheduler/jobCollections",
    validator: validate_JobCollectionsListBySubscription_593647, base: "",
    url: url_JobCollectionsListBySubscription_593648, schemes: {Scheme.Https})
type
  Call_JobCollectionsListByResourceGroup_593958 = ref object of OpenApiRestCall_593424
proc url_JobCollectionsListByResourceGroup_593960(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Scheduler/jobCollections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCollectionsListByResourceGroup_593959(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all job collections under specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593961 = path.getOrDefault("resourceGroupName")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "resourceGroupName", valid_593961
  var valid_593962 = path.getOrDefault("subscriptionId")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "subscriptionId", valid_593962
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593963 = query.getOrDefault("api-version")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "api-version", valid_593963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593964: Call_JobCollectionsListByResourceGroup_593958;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all job collections under specified resource group.
  ## 
  let valid = call_593964.validator(path, query, header, formData, body)
  let scheme = call_593964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593964.url(scheme.get, call_593964.host, call_593964.base,
                         call_593964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593964, url, valid)

proc call*(call_593965: Call_JobCollectionsListByResourceGroup_593958;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## jobCollectionsListByResourceGroup
  ## Gets all job collections under specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_593966 = newJObject()
  var query_593967 = newJObject()
  add(path_593966, "resourceGroupName", newJString(resourceGroupName))
  add(query_593967, "api-version", newJString(apiVersion))
  add(path_593966, "subscriptionId", newJString(subscriptionId))
  result = call_593965.call(path_593966, query_593967, nil, nil, nil)

var jobCollectionsListByResourceGroup* = Call_JobCollectionsListByResourceGroup_593958(
    name: "jobCollectionsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections",
    validator: validate_JobCollectionsListByResourceGroup_593959, base: "",
    url: url_JobCollectionsListByResourceGroup_593960, schemes: {Scheme.Https})
type
  Call_JobCollectionsCreateOrUpdate_593979 = ref object of OpenApiRestCall_593424
proc url_JobCollectionsCreateOrUpdate_593981(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobCollectionName" in path,
        "`jobCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Scheduler/jobCollections/"),
               (kind: VariableSegment, value: "jobCollectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCollectionsCreateOrUpdate_593980(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provisions a new job collection or updates an existing job collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   jobCollectionName: JString (required)
  ##                    : The job collection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593999 = path.getOrDefault("resourceGroupName")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "resourceGroupName", valid_593999
  var valid_594000 = path.getOrDefault("subscriptionId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "subscriptionId", valid_594000
  var valid_594001 = path.getOrDefault("jobCollectionName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "jobCollectionName", valid_594001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594002 = query.getOrDefault("api-version")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "api-version", valid_594002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   jobCollection: JObject (required)
  ##                : The job collection definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_JobCollectionsCreateOrUpdate_593979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions a new job collection or updates an existing job collection.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_JobCollectionsCreateOrUpdate_593979;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobCollectionName: string; jobCollection: JsonNode): Recallable =
  ## jobCollectionsCreateOrUpdate
  ## Provisions a new job collection or updates an existing job collection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   jobCollectionName: string (required)
  ##                    : The job collection name.
  ##   jobCollection: JObject (required)
  ##                : The job collection definition.
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  var body_594008 = newJObject()
  add(path_594006, "resourceGroupName", newJString(resourceGroupName))
  add(query_594007, "api-version", newJString(apiVersion))
  add(path_594006, "subscriptionId", newJString(subscriptionId))
  add(path_594006, "jobCollectionName", newJString(jobCollectionName))
  if jobCollection != nil:
    body_594008 = jobCollection
  result = call_594005.call(path_594006, query_594007, nil, nil, body_594008)

var jobCollectionsCreateOrUpdate* = Call_JobCollectionsCreateOrUpdate_593979(
    name: "jobCollectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}",
    validator: validate_JobCollectionsCreateOrUpdate_593980, base: "",
    url: url_JobCollectionsCreateOrUpdate_593981, schemes: {Scheme.Https})
type
  Call_JobCollectionsGet_593968 = ref object of OpenApiRestCall_593424
proc url_JobCollectionsGet_593970(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobCollectionName" in path,
        "`jobCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Scheduler/jobCollections/"),
               (kind: VariableSegment, value: "jobCollectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCollectionsGet_593969(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a job collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   jobCollectionName: JString (required)
  ##                    : The job collection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593971 = path.getOrDefault("resourceGroupName")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "resourceGroupName", valid_593971
  var valid_593972 = path.getOrDefault("subscriptionId")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "subscriptionId", valid_593972
  var valid_593973 = path.getOrDefault("jobCollectionName")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "jobCollectionName", valid_593973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593974 = query.getOrDefault("api-version")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "api-version", valid_593974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_JobCollectionsGet_593968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job collection.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_JobCollectionsGet_593968; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobCollectionName: string): Recallable =
  ## jobCollectionsGet
  ## Gets a job collection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   jobCollectionName: string (required)
  ##                    : The job collection name.
  var path_593977 = newJObject()
  var query_593978 = newJObject()
  add(path_593977, "resourceGroupName", newJString(resourceGroupName))
  add(query_593978, "api-version", newJString(apiVersion))
  add(path_593977, "subscriptionId", newJString(subscriptionId))
  add(path_593977, "jobCollectionName", newJString(jobCollectionName))
  result = call_593976.call(path_593977, query_593978, nil, nil, nil)

var jobCollectionsGet* = Call_JobCollectionsGet_593968(name: "jobCollectionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}",
    validator: validate_JobCollectionsGet_593969, base: "",
    url: url_JobCollectionsGet_593970, schemes: {Scheme.Https})
type
  Call_JobCollectionsPatch_594020 = ref object of OpenApiRestCall_593424
proc url_JobCollectionsPatch_594022(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobCollectionName" in path,
        "`jobCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Scheduler/jobCollections/"),
               (kind: VariableSegment, value: "jobCollectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCollectionsPatch_594021(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Patches an existing job collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   jobCollectionName: JString (required)
  ##                    : The job collection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594023 = path.getOrDefault("resourceGroupName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "resourceGroupName", valid_594023
  var valid_594024 = path.getOrDefault("subscriptionId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "subscriptionId", valid_594024
  var valid_594025 = path.getOrDefault("jobCollectionName")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "jobCollectionName", valid_594025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594026 = query.getOrDefault("api-version")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "api-version", valid_594026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   jobCollection: JObject (required)
  ##                : The job collection definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594028: Call_JobCollectionsPatch_594020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches an existing job collection.
  ## 
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_JobCollectionsPatch_594020; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobCollectionName: string;
          jobCollection: JsonNode): Recallable =
  ## jobCollectionsPatch
  ## Patches an existing job collection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   jobCollectionName: string (required)
  ##                    : The job collection name.
  ##   jobCollection: JObject (required)
  ##                : The job collection definition.
  var path_594030 = newJObject()
  var query_594031 = newJObject()
  var body_594032 = newJObject()
  add(path_594030, "resourceGroupName", newJString(resourceGroupName))
  add(query_594031, "api-version", newJString(apiVersion))
  add(path_594030, "subscriptionId", newJString(subscriptionId))
  add(path_594030, "jobCollectionName", newJString(jobCollectionName))
  if jobCollection != nil:
    body_594032 = jobCollection
  result = call_594029.call(path_594030, query_594031, nil, nil, body_594032)

var jobCollectionsPatch* = Call_JobCollectionsPatch_594020(
    name: "jobCollectionsPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}",
    validator: validate_JobCollectionsPatch_594021, base: "",
    url: url_JobCollectionsPatch_594022, schemes: {Scheme.Https})
type
  Call_JobCollectionsDelete_594009 = ref object of OpenApiRestCall_593424
proc url_JobCollectionsDelete_594011(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobCollectionName" in path,
        "`jobCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Scheduler/jobCollections/"),
               (kind: VariableSegment, value: "jobCollectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCollectionsDelete_594010(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a job collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   jobCollectionName: JString (required)
  ##                    : The job collection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594012 = path.getOrDefault("resourceGroupName")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "resourceGroupName", valid_594012
  var valid_594013 = path.getOrDefault("subscriptionId")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "subscriptionId", valid_594013
  var valid_594014 = path.getOrDefault("jobCollectionName")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "jobCollectionName", valid_594014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594015 = query.getOrDefault("api-version")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "api-version", valid_594015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594016: Call_JobCollectionsDelete_594009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job collection.
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_JobCollectionsDelete_594009;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobCollectionName: string): Recallable =
  ## jobCollectionsDelete
  ## Deletes a job collection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   jobCollectionName: string (required)
  ##                    : The job collection name.
  var path_594018 = newJObject()
  var query_594019 = newJObject()
  add(path_594018, "resourceGroupName", newJString(resourceGroupName))
  add(query_594019, "api-version", newJString(apiVersion))
  add(path_594018, "subscriptionId", newJString(subscriptionId))
  add(path_594018, "jobCollectionName", newJString(jobCollectionName))
  result = call_594017.call(path_594018, query_594019, nil, nil, nil)

var jobCollectionsDelete* = Call_JobCollectionsDelete_594009(
    name: "jobCollectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}",
    validator: validate_JobCollectionsDelete_594010, base: "",
    url: url_JobCollectionsDelete_594011, schemes: {Scheme.Https})
type
  Call_JobCollectionsDisable_594033 = ref object of OpenApiRestCall_593424
proc url_JobCollectionsDisable_594035(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobCollectionName" in path,
        "`jobCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Scheduler/jobCollections/"),
               (kind: VariableSegment, value: "jobCollectionName"),
               (kind: ConstantSegment, value: "/disable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCollectionsDisable_594034(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Disables all of the jobs in the job collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   jobCollectionName: JString (required)
  ##                    : The job collection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594036 = path.getOrDefault("resourceGroupName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "resourceGroupName", valid_594036
  var valid_594037 = path.getOrDefault("subscriptionId")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "subscriptionId", valid_594037
  var valid_594038 = path.getOrDefault("jobCollectionName")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "jobCollectionName", valid_594038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594039 = query.getOrDefault("api-version")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "api-version", valid_594039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594040: Call_JobCollectionsDisable_594033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disables all of the jobs in the job collection.
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_JobCollectionsDisable_594033;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobCollectionName: string): Recallable =
  ## jobCollectionsDisable
  ## Disables all of the jobs in the job collection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   jobCollectionName: string (required)
  ##                    : The job collection name.
  var path_594042 = newJObject()
  var query_594043 = newJObject()
  add(path_594042, "resourceGroupName", newJString(resourceGroupName))
  add(query_594043, "api-version", newJString(apiVersion))
  add(path_594042, "subscriptionId", newJString(subscriptionId))
  add(path_594042, "jobCollectionName", newJString(jobCollectionName))
  result = call_594041.call(path_594042, query_594043, nil, nil, nil)

var jobCollectionsDisable* = Call_JobCollectionsDisable_594033(
    name: "jobCollectionsDisable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/disable",
    validator: validate_JobCollectionsDisable_594034, base: "",
    url: url_JobCollectionsDisable_594035, schemes: {Scheme.Https})
type
  Call_JobCollectionsEnable_594044 = ref object of OpenApiRestCall_593424
proc url_JobCollectionsEnable_594046(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobCollectionName" in path,
        "`jobCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Scheduler/jobCollections/"),
               (kind: VariableSegment, value: "jobCollectionName"),
               (kind: ConstantSegment, value: "/enable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCollectionsEnable_594045(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enables all of the jobs in the job collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   jobCollectionName: JString (required)
  ##                    : The job collection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594047 = path.getOrDefault("resourceGroupName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "resourceGroupName", valid_594047
  var valid_594048 = path.getOrDefault("subscriptionId")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "subscriptionId", valid_594048
  var valid_594049 = path.getOrDefault("jobCollectionName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "jobCollectionName", valid_594049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594050 = query.getOrDefault("api-version")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "api-version", valid_594050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594051: Call_JobCollectionsEnable_594044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables all of the jobs in the job collection.
  ## 
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_JobCollectionsEnable_594044;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobCollectionName: string): Recallable =
  ## jobCollectionsEnable
  ## Enables all of the jobs in the job collection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   jobCollectionName: string (required)
  ##                    : The job collection name.
  var path_594053 = newJObject()
  var query_594054 = newJObject()
  add(path_594053, "resourceGroupName", newJString(resourceGroupName))
  add(query_594054, "api-version", newJString(apiVersion))
  add(path_594053, "subscriptionId", newJString(subscriptionId))
  add(path_594053, "jobCollectionName", newJString(jobCollectionName))
  result = call_594052.call(path_594053, query_594054, nil, nil, nil)

var jobCollectionsEnable* = Call_JobCollectionsEnable_594044(
    name: "jobCollectionsEnable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/enable",
    validator: validate_JobCollectionsEnable_594045, base: "",
    url: url_JobCollectionsEnable_594046, schemes: {Scheme.Https})
type
  Call_JobsList_594055 = ref object of OpenApiRestCall_593424
proc url_JobsList_594057(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobCollectionName" in path,
        "`jobCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Scheduler/jobCollections/"),
               (kind: VariableSegment, value: "jobCollectionName"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsList_594056(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all jobs under the specified job collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   jobCollectionName: JString (required)
  ##                    : The job collection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594059 = path.getOrDefault("resourceGroupName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "resourceGroupName", valid_594059
  var valid_594060 = path.getOrDefault("subscriptionId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "subscriptionId", valid_594060
  var valid_594061 = path.getOrDefault("jobCollectionName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "jobCollectionName", valid_594061
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of jobs to request, in the of range of [1..100].
  ##   $skip: JInt
  ##        : The (0-based) index of the job history list from which to begin requesting entries.
  ##   $filter: JString
  ##          : The filter to apply on the job state.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594062 = query.getOrDefault("api-version")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "api-version", valid_594062
  var valid_594063 = query.getOrDefault("$top")
  valid_594063 = validateParameter(valid_594063, JInt, required = false, default = nil)
  if valid_594063 != nil:
    section.add "$top", valid_594063
  var valid_594064 = query.getOrDefault("$skip")
  valid_594064 = validateParameter(valid_594064, JInt, required = false, default = nil)
  if valid_594064 != nil:
    section.add "$skip", valid_594064
  var valid_594065 = query.getOrDefault("$filter")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "$filter", valid_594065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_JobsList_594055; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all jobs under the specified job collection.
  ## 
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_JobsList_594055; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobCollectionName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## jobsList
  ## Lists all jobs under the specified job collection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of jobs to request, in the of range of [1..100].
  ##   Skip: int
  ##       : The (0-based) index of the job history list from which to begin requesting entries.
  ##   jobCollectionName: string (required)
  ##                    : The job collection name.
  ##   Filter: string
  ##         : The filter to apply on the job state.
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  add(path_594068, "resourceGroupName", newJString(resourceGroupName))
  add(query_594069, "api-version", newJString(apiVersion))
  add(path_594068, "subscriptionId", newJString(subscriptionId))
  add(query_594069, "$top", newJInt(Top))
  add(query_594069, "$skip", newJInt(Skip))
  add(path_594068, "jobCollectionName", newJString(jobCollectionName))
  add(query_594069, "$filter", newJString(Filter))
  result = call_594067.call(path_594068, query_594069, nil, nil, nil)

var jobsList* = Call_JobsList_594055(name: "jobsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/jobs",
                                  validator: validate_JobsList_594056, base: "",
                                  url: url_JobsList_594057,
                                  schemes: {Scheme.Https})
type
  Call_JobsCreateOrUpdate_594082 = ref object of OpenApiRestCall_593424
proc url_JobsCreateOrUpdate_594084(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobCollectionName" in path,
        "`jobCollectionName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Scheduler/jobCollections/"),
               (kind: VariableSegment, value: "jobCollectionName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsCreateOrUpdate_594083(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Provisions a new job or updates an existing job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   jobName: JString (required)
  ##          : The job name.
  ##   jobCollectionName: JString (required)
  ##                    : The job collection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594085 = path.getOrDefault("resourceGroupName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "resourceGroupName", valid_594085
  var valid_594086 = path.getOrDefault("subscriptionId")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "subscriptionId", valid_594086
  var valid_594087 = path.getOrDefault("jobName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "jobName", valid_594087
  var valid_594088 = path.getOrDefault("jobCollectionName")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "jobCollectionName", valid_594088
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594089 = query.getOrDefault("api-version")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "api-version", valid_594089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   job: JObject (required)
  ##      : The job definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594091: Call_JobsCreateOrUpdate_594082; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions a new job or updates an existing job.
  ## 
  let valid = call_594091.validator(path, query, header, formData, body)
  let scheme = call_594091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594091.url(scheme.get, call_594091.host, call_594091.base,
                         call_594091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594091, url, valid)

proc call*(call_594092: Call_JobsCreateOrUpdate_594082; resourceGroupName: string;
          apiVersion: string; job: JsonNode; subscriptionId: string; jobName: string;
          jobCollectionName: string): Recallable =
  ## jobsCreateOrUpdate
  ## Provisions a new job or updates an existing job.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   job: JObject (required)
  ##      : The job definition.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   jobName: string (required)
  ##          : The job name.
  ##   jobCollectionName: string (required)
  ##                    : The job collection name.
  var path_594093 = newJObject()
  var query_594094 = newJObject()
  var body_594095 = newJObject()
  add(path_594093, "resourceGroupName", newJString(resourceGroupName))
  add(query_594094, "api-version", newJString(apiVersion))
  if job != nil:
    body_594095 = job
  add(path_594093, "subscriptionId", newJString(subscriptionId))
  add(path_594093, "jobName", newJString(jobName))
  add(path_594093, "jobCollectionName", newJString(jobCollectionName))
  result = call_594092.call(path_594093, query_594094, nil, nil, body_594095)

var jobsCreateOrUpdate* = Call_JobsCreateOrUpdate_594082(
    name: "jobsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/jobs/{jobName}",
    validator: validate_JobsCreateOrUpdate_594083, base: "",
    url: url_JobsCreateOrUpdate_594084, schemes: {Scheme.Https})
type
  Call_JobsGet_594070 = ref object of OpenApiRestCall_593424
proc url_JobsGet_594072(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobCollectionName" in path,
        "`jobCollectionName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Scheduler/jobCollections/"),
               (kind: VariableSegment, value: "jobCollectionName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsGet_594071(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   jobName: JString (required)
  ##          : The job name.
  ##   jobCollectionName: JString (required)
  ##                    : The job collection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594073 = path.getOrDefault("resourceGroupName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "resourceGroupName", valid_594073
  var valid_594074 = path.getOrDefault("subscriptionId")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "subscriptionId", valid_594074
  var valid_594075 = path.getOrDefault("jobName")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "jobName", valid_594075
  var valid_594076 = path.getOrDefault("jobCollectionName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "jobCollectionName", valid_594076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594077 = query.getOrDefault("api-version")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "api-version", valid_594077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594078: Call_JobsGet_594070; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job.
  ## 
  let valid = call_594078.validator(path, query, header, formData, body)
  let scheme = call_594078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594078.url(scheme.get, call_594078.host, call_594078.base,
                         call_594078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594078, url, valid)

proc call*(call_594079: Call_JobsGet_594070; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          jobCollectionName: string): Recallable =
  ## jobsGet
  ## Gets a job.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   jobName: string (required)
  ##          : The job name.
  ##   jobCollectionName: string (required)
  ##                    : The job collection name.
  var path_594080 = newJObject()
  var query_594081 = newJObject()
  add(path_594080, "resourceGroupName", newJString(resourceGroupName))
  add(query_594081, "api-version", newJString(apiVersion))
  add(path_594080, "subscriptionId", newJString(subscriptionId))
  add(path_594080, "jobName", newJString(jobName))
  add(path_594080, "jobCollectionName", newJString(jobCollectionName))
  result = call_594079.call(path_594080, query_594081, nil, nil, nil)

var jobsGet* = Call_JobsGet_594070(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/jobs/{jobName}",
                                validator: validate_JobsGet_594071, base: "",
                                url: url_JobsGet_594072, schemes: {Scheme.Https})
type
  Call_JobsPatch_594108 = ref object of OpenApiRestCall_593424
proc url_JobsPatch_594110(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobCollectionName" in path,
        "`jobCollectionName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Scheduler/jobCollections/"),
               (kind: VariableSegment, value: "jobCollectionName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsPatch_594109(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches an existing job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   jobName: JString (required)
  ##          : The job name.
  ##   jobCollectionName: JString (required)
  ##                    : The job collection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594111 = path.getOrDefault("resourceGroupName")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "resourceGroupName", valid_594111
  var valid_594112 = path.getOrDefault("subscriptionId")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "subscriptionId", valid_594112
  var valid_594113 = path.getOrDefault("jobName")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "jobName", valid_594113
  var valid_594114 = path.getOrDefault("jobCollectionName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "jobCollectionName", valid_594114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594115 = query.getOrDefault("api-version")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "api-version", valid_594115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   job: JObject (required)
  ##      : The job definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594117: Call_JobsPatch_594108; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches an existing job.
  ## 
  let valid = call_594117.validator(path, query, header, formData, body)
  let scheme = call_594117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594117.url(scheme.get, call_594117.host, call_594117.base,
                         call_594117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594117, url, valid)

proc call*(call_594118: Call_JobsPatch_594108; resourceGroupName: string;
          apiVersion: string; job: JsonNode; subscriptionId: string; jobName: string;
          jobCollectionName: string): Recallable =
  ## jobsPatch
  ## Patches an existing job.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   job: JObject (required)
  ##      : The job definition.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   jobName: string (required)
  ##          : The job name.
  ##   jobCollectionName: string (required)
  ##                    : The job collection name.
  var path_594119 = newJObject()
  var query_594120 = newJObject()
  var body_594121 = newJObject()
  add(path_594119, "resourceGroupName", newJString(resourceGroupName))
  add(query_594120, "api-version", newJString(apiVersion))
  if job != nil:
    body_594121 = job
  add(path_594119, "subscriptionId", newJString(subscriptionId))
  add(path_594119, "jobName", newJString(jobName))
  add(path_594119, "jobCollectionName", newJString(jobCollectionName))
  result = call_594118.call(path_594119, query_594120, nil, nil, body_594121)

var jobsPatch* = Call_JobsPatch_594108(name: "jobsPatch", meth: HttpMethod.HttpPatch,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/jobs/{jobName}",
                                    validator: validate_JobsPatch_594109,
                                    base: "", url: url_JobsPatch_594110,
                                    schemes: {Scheme.Https})
type
  Call_JobsDelete_594096 = ref object of OpenApiRestCall_593424
proc url_JobsDelete_594098(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobCollectionName" in path,
        "`jobCollectionName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Scheduler/jobCollections/"),
               (kind: VariableSegment, value: "jobCollectionName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsDelete_594097(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   jobName: JString (required)
  ##          : The job name.
  ##   jobCollectionName: JString (required)
  ##                    : The job collection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594099 = path.getOrDefault("resourceGroupName")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "resourceGroupName", valid_594099
  var valid_594100 = path.getOrDefault("subscriptionId")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "subscriptionId", valid_594100
  var valid_594101 = path.getOrDefault("jobName")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "jobName", valid_594101
  var valid_594102 = path.getOrDefault("jobCollectionName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "jobCollectionName", valid_594102
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594103 = query.getOrDefault("api-version")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "api-version", valid_594103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594104: Call_JobsDelete_594096; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job.
  ## 
  let valid = call_594104.validator(path, query, header, formData, body)
  let scheme = call_594104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594104.url(scheme.get, call_594104.host, call_594104.base,
                         call_594104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594104, url, valid)

proc call*(call_594105: Call_JobsDelete_594096; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          jobCollectionName: string): Recallable =
  ## jobsDelete
  ## Deletes a job.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   jobName: string (required)
  ##          : The job name.
  ##   jobCollectionName: string (required)
  ##                    : The job collection name.
  var path_594106 = newJObject()
  var query_594107 = newJObject()
  add(path_594106, "resourceGroupName", newJString(resourceGroupName))
  add(query_594107, "api-version", newJString(apiVersion))
  add(path_594106, "subscriptionId", newJString(subscriptionId))
  add(path_594106, "jobName", newJString(jobName))
  add(path_594106, "jobCollectionName", newJString(jobCollectionName))
  result = call_594105.call(path_594106, query_594107, nil, nil, nil)

var jobsDelete* = Call_JobsDelete_594096(name: "jobsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/jobs/{jobName}",
                                      validator: validate_JobsDelete_594097,
                                      base: "", url: url_JobsDelete_594098,
                                      schemes: {Scheme.Https})
type
  Call_JobsListJobHistory_594122 = ref object of OpenApiRestCall_593424
proc url_JobsListJobHistory_594124(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobCollectionName" in path,
        "`jobCollectionName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Scheduler/jobCollections/"),
               (kind: VariableSegment, value: "jobCollectionName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/history")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListJobHistory_594123(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists job history.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   jobName: JString (required)
  ##          : The job name.
  ##   jobCollectionName: JString (required)
  ##                    : The job collection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594125 = path.getOrDefault("resourceGroupName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "resourceGroupName", valid_594125
  var valid_594126 = path.getOrDefault("subscriptionId")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "subscriptionId", valid_594126
  var valid_594127 = path.getOrDefault("jobName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "jobName", valid_594127
  var valid_594128 = path.getOrDefault("jobCollectionName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "jobCollectionName", valid_594128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : the number of job history to request, in the of range of [1..100].
  ##   $skip: JInt
  ##        : The (0-based) index of the job history list from which to begin requesting entries.
  ##   $filter: JString
  ##          : The filter to apply on the job state.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594129 = query.getOrDefault("api-version")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "api-version", valid_594129
  var valid_594130 = query.getOrDefault("$top")
  valid_594130 = validateParameter(valid_594130, JInt, required = false, default = nil)
  if valid_594130 != nil:
    section.add "$top", valid_594130
  var valid_594131 = query.getOrDefault("$skip")
  valid_594131 = validateParameter(valid_594131, JInt, required = false, default = nil)
  if valid_594131 != nil:
    section.add "$skip", valid_594131
  var valid_594132 = query.getOrDefault("$filter")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "$filter", valid_594132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594133: Call_JobsListJobHistory_594122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists job history.
  ## 
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_JobsListJobHistory_594122; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          jobCollectionName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## jobsListJobHistory
  ## Lists job history.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   jobName: string (required)
  ##          : The job name.
  ##   Top: int
  ##      : the number of job history to request, in the of range of [1..100].
  ##   Skip: int
  ##       : The (0-based) index of the job history list from which to begin requesting entries.
  ##   jobCollectionName: string (required)
  ##                    : The job collection name.
  ##   Filter: string
  ##         : The filter to apply on the job state.
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  add(path_594135, "resourceGroupName", newJString(resourceGroupName))
  add(query_594136, "api-version", newJString(apiVersion))
  add(path_594135, "subscriptionId", newJString(subscriptionId))
  add(path_594135, "jobName", newJString(jobName))
  add(query_594136, "$top", newJInt(Top))
  add(query_594136, "$skip", newJInt(Skip))
  add(path_594135, "jobCollectionName", newJString(jobCollectionName))
  add(query_594136, "$filter", newJString(Filter))
  result = call_594134.call(path_594135, query_594136, nil, nil, nil)

var jobsListJobHistory* = Call_JobsListJobHistory_594122(
    name: "jobsListJobHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/jobs/{jobName}/history",
    validator: validate_JobsListJobHistory_594123, base: "",
    url: url_JobsListJobHistory_594124, schemes: {Scheme.Https})
type
  Call_JobsRun_594137 = ref object of OpenApiRestCall_593424
proc url_JobsRun_594139(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobCollectionName" in path,
        "`jobCollectionName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Scheduler/jobCollections/"),
               (kind: VariableSegment, value: "jobCollectionName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsRun_594138(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Runs a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   jobName: JString (required)
  ##          : The job name.
  ##   jobCollectionName: JString (required)
  ##                    : The job collection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594140 = path.getOrDefault("resourceGroupName")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "resourceGroupName", valid_594140
  var valid_594141 = path.getOrDefault("subscriptionId")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "subscriptionId", valid_594141
  var valid_594142 = path.getOrDefault("jobName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "jobName", valid_594142
  var valid_594143 = path.getOrDefault("jobCollectionName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "jobCollectionName", valid_594143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594144 = query.getOrDefault("api-version")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "api-version", valid_594144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594145: Call_JobsRun_594137; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a job.
  ## 
  let valid = call_594145.validator(path, query, header, formData, body)
  let scheme = call_594145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594145.url(scheme.get, call_594145.host, call_594145.base,
                         call_594145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594145, url, valid)

proc call*(call_594146: Call_JobsRun_594137; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          jobCollectionName: string): Recallable =
  ## jobsRun
  ## Runs a job.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   jobName: string (required)
  ##          : The job name.
  ##   jobCollectionName: string (required)
  ##                    : The job collection name.
  var path_594147 = newJObject()
  var query_594148 = newJObject()
  add(path_594147, "resourceGroupName", newJString(resourceGroupName))
  add(query_594148, "api-version", newJString(apiVersion))
  add(path_594147, "subscriptionId", newJString(subscriptionId))
  add(path_594147, "jobName", newJString(jobName))
  add(path_594147, "jobCollectionName", newJString(jobCollectionName))
  result = call_594146.call(path_594147, query_594148, nil, nil, nil)

var jobsRun* = Call_JobsRun_594137(name: "jobsRun", meth: HttpMethod.HttpPost,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/jobs/{jobName}/run",
                                validator: validate_JobsRun_594138, base: "",
                                url: url_JobsRun_594139, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
