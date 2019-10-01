
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SchedulerManagementClient
## version: 2016-01-01
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "scheduler"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobCollectionsListBySubscription_567863 = ref object of OpenApiRestCall_567641
proc url_JobCollectionsListBySubscription_567865(protocol: Scheme; host: string;
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

proc validate_JobCollectionsListBySubscription_567864(path: JsonNode;
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
  var valid_568038 = path.getOrDefault("subscriptionId")
  valid_568038 = validateParameter(valid_568038, JString, required = true,
                                 default = nil)
  if valid_568038 != nil:
    section.add "subscriptionId", valid_568038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568039 = query.getOrDefault("api-version")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = nil)
  if valid_568039 != nil:
    section.add "api-version", valid_568039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568062: Call_JobCollectionsListBySubscription_567863;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all job collections under specified subscription.
  ## 
  let valid = call_568062.validator(path, query, header, formData, body)
  let scheme = call_568062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568062.url(scheme.get, call_568062.host, call_568062.base,
                         call_568062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568062, url, valid)

proc call*(call_568133: Call_JobCollectionsListBySubscription_567863;
          apiVersion: string; subscriptionId: string): Recallable =
  ## jobCollectionsListBySubscription
  ## Gets all job collections under specified subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_568134 = newJObject()
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  add(path_568134, "subscriptionId", newJString(subscriptionId))
  result = call_568133.call(path_568134, query_568136, nil, nil, nil)

var jobCollectionsListBySubscription* = Call_JobCollectionsListBySubscription_567863(
    name: "jobCollectionsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Scheduler/jobCollections",
    validator: validate_JobCollectionsListBySubscription_567864, base: "",
    url: url_JobCollectionsListBySubscription_567865, schemes: {Scheme.Https})
type
  Call_JobCollectionsListByResourceGroup_568175 = ref object of OpenApiRestCall_567641
proc url_JobCollectionsListByResourceGroup_568177(protocol: Scheme; host: string;
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

proc validate_JobCollectionsListByResourceGroup_568176(path: JsonNode;
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
  var valid_568178 = path.getOrDefault("resourceGroupName")
  valid_568178 = validateParameter(valid_568178, JString, required = true,
                                 default = nil)
  if valid_568178 != nil:
    section.add "resourceGroupName", valid_568178
  var valid_568179 = path.getOrDefault("subscriptionId")
  valid_568179 = validateParameter(valid_568179, JString, required = true,
                                 default = nil)
  if valid_568179 != nil:
    section.add "subscriptionId", valid_568179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568180 = query.getOrDefault("api-version")
  valid_568180 = validateParameter(valid_568180, JString, required = true,
                                 default = nil)
  if valid_568180 != nil:
    section.add "api-version", valid_568180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568181: Call_JobCollectionsListByResourceGroup_568175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all job collections under specified resource group.
  ## 
  let valid = call_568181.validator(path, query, header, formData, body)
  let scheme = call_568181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568181.url(scheme.get, call_568181.host, call_568181.base,
                         call_568181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568181, url, valid)

proc call*(call_568182: Call_JobCollectionsListByResourceGroup_568175;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## jobCollectionsListByResourceGroup
  ## Gets all job collections under specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_568183 = newJObject()
  var query_568184 = newJObject()
  add(path_568183, "resourceGroupName", newJString(resourceGroupName))
  add(query_568184, "api-version", newJString(apiVersion))
  add(path_568183, "subscriptionId", newJString(subscriptionId))
  result = call_568182.call(path_568183, query_568184, nil, nil, nil)

var jobCollectionsListByResourceGroup* = Call_JobCollectionsListByResourceGroup_568175(
    name: "jobCollectionsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections",
    validator: validate_JobCollectionsListByResourceGroup_568176, base: "",
    url: url_JobCollectionsListByResourceGroup_568177, schemes: {Scheme.Https})
type
  Call_JobCollectionsCreateOrUpdate_568196 = ref object of OpenApiRestCall_567641
proc url_JobCollectionsCreateOrUpdate_568198(protocol: Scheme; host: string;
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

proc validate_JobCollectionsCreateOrUpdate_568197(path: JsonNode; query: JsonNode;
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
  var valid_568216 = path.getOrDefault("resourceGroupName")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "resourceGroupName", valid_568216
  var valid_568217 = path.getOrDefault("subscriptionId")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "subscriptionId", valid_568217
  var valid_568218 = path.getOrDefault("jobCollectionName")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "jobCollectionName", valid_568218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568219 = query.getOrDefault("api-version")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "api-version", valid_568219
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

proc call*(call_568221: Call_JobCollectionsCreateOrUpdate_568196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions a new job collection or updates an existing job collection.
  ## 
  let valid = call_568221.validator(path, query, header, formData, body)
  let scheme = call_568221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568221.url(scheme.get, call_568221.host, call_568221.base,
                         call_568221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568221, url, valid)

proc call*(call_568222: Call_JobCollectionsCreateOrUpdate_568196;
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
  var path_568223 = newJObject()
  var query_568224 = newJObject()
  var body_568225 = newJObject()
  add(path_568223, "resourceGroupName", newJString(resourceGroupName))
  add(query_568224, "api-version", newJString(apiVersion))
  add(path_568223, "subscriptionId", newJString(subscriptionId))
  add(path_568223, "jobCollectionName", newJString(jobCollectionName))
  if jobCollection != nil:
    body_568225 = jobCollection
  result = call_568222.call(path_568223, query_568224, nil, nil, body_568225)

var jobCollectionsCreateOrUpdate* = Call_JobCollectionsCreateOrUpdate_568196(
    name: "jobCollectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}",
    validator: validate_JobCollectionsCreateOrUpdate_568197, base: "",
    url: url_JobCollectionsCreateOrUpdate_568198, schemes: {Scheme.Https})
type
  Call_JobCollectionsGet_568185 = ref object of OpenApiRestCall_567641
proc url_JobCollectionsGet_568187(protocol: Scheme; host: string; base: string;
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

proc validate_JobCollectionsGet_568186(path: JsonNode; query: JsonNode;
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
  var valid_568188 = path.getOrDefault("resourceGroupName")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "resourceGroupName", valid_568188
  var valid_568189 = path.getOrDefault("subscriptionId")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "subscriptionId", valid_568189
  var valid_568190 = path.getOrDefault("jobCollectionName")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "jobCollectionName", valid_568190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568191 = query.getOrDefault("api-version")
  valid_568191 = validateParameter(valid_568191, JString, required = true,
                                 default = nil)
  if valid_568191 != nil:
    section.add "api-version", valid_568191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568192: Call_JobCollectionsGet_568185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job collection.
  ## 
  let valid = call_568192.validator(path, query, header, formData, body)
  let scheme = call_568192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568192.url(scheme.get, call_568192.host, call_568192.base,
                         call_568192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568192, url, valid)

proc call*(call_568193: Call_JobCollectionsGet_568185; resourceGroupName: string;
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
  var path_568194 = newJObject()
  var query_568195 = newJObject()
  add(path_568194, "resourceGroupName", newJString(resourceGroupName))
  add(query_568195, "api-version", newJString(apiVersion))
  add(path_568194, "subscriptionId", newJString(subscriptionId))
  add(path_568194, "jobCollectionName", newJString(jobCollectionName))
  result = call_568193.call(path_568194, query_568195, nil, nil, nil)

var jobCollectionsGet* = Call_JobCollectionsGet_568185(name: "jobCollectionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}",
    validator: validate_JobCollectionsGet_568186, base: "",
    url: url_JobCollectionsGet_568187, schemes: {Scheme.Https})
type
  Call_JobCollectionsPatch_568237 = ref object of OpenApiRestCall_567641
proc url_JobCollectionsPatch_568239(protocol: Scheme; host: string; base: string;
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

proc validate_JobCollectionsPatch_568238(path: JsonNode; query: JsonNode;
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
  var valid_568240 = path.getOrDefault("resourceGroupName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "resourceGroupName", valid_568240
  var valid_568241 = path.getOrDefault("subscriptionId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "subscriptionId", valid_568241
  var valid_568242 = path.getOrDefault("jobCollectionName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "jobCollectionName", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568243 = query.getOrDefault("api-version")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "api-version", valid_568243
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

proc call*(call_568245: Call_JobCollectionsPatch_568237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches an existing job collection.
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_JobCollectionsPatch_568237; resourceGroupName: string;
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
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  var body_568249 = newJObject()
  add(path_568247, "resourceGroupName", newJString(resourceGroupName))
  add(query_568248, "api-version", newJString(apiVersion))
  add(path_568247, "subscriptionId", newJString(subscriptionId))
  add(path_568247, "jobCollectionName", newJString(jobCollectionName))
  if jobCollection != nil:
    body_568249 = jobCollection
  result = call_568246.call(path_568247, query_568248, nil, nil, body_568249)

var jobCollectionsPatch* = Call_JobCollectionsPatch_568237(
    name: "jobCollectionsPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}",
    validator: validate_JobCollectionsPatch_568238, base: "",
    url: url_JobCollectionsPatch_568239, schemes: {Scheme.Https})
type
  Call_JobCollectionsDelete_568226 = ref object of OpenApiRestCall_567641
proc url_JobCollectionsDelete_568228(protocol: Scheme; host: string; base: string;
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

proc validate_JobCollectionsDelete_568227(path: JsonNode; query: JsonNode;
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
  var valid_568229 = path.getOrDefault("resourceGroupName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "resourceGroupName", valid_568229
  var valid_568230 = path.getOrDefault("subscriptionId")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "subscriptionId", valid_568230
  var valid_568231 = path.getOrDefault("jobCollectionName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "jobCollectionName", valid_568231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568232 = query.getOrDefault("api-version")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "api-version", valid_568232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_JobCollectionsDelete_568226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job collection.
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_JobCollectionsDelete_568226;
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
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(path_568235, "resourceGroupName", newJString(resourceGroupName))
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  add(path_568235, "jobCollectionName", newJString(jobCollectionName))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var jobCollectionsDelete* = Call_JobCollectionsDelete_568226(
    name: "jobCollectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}",
    validator: validate_JobCollectionsDelete_568227, base: "",
    url: url_JobCollectionsDelete_568228, schemes: {Scheme.Https})
type
  Call_JobCollectionsDisable_568250 = ref object of OpenApiRestCall_567641
proc url_JobCollectionsDisable_568252(protocol: Scheme; host: string; base: string;
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

proc validate_JobCollectionsDisable_568251(path: JsonNode; query: JsonNode;
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
  var valid_568253 = path.getOrDefault("resourceGroupName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "resourceGroupName", valid_568253
  var valid_568254 = path.getOrDefault("subscriptionId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "subscriptionId", valid_568254
  var valid_568255 = path.getOrDefault("jobCollectionName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "jobCollectionName", valid_568255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568257: Call_JobCollectionsDisable_568250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disables all of the jobs in the job collection.
  ## 
  let valid = call_568257.validator(path, query, header, formData, body)
  let scheme = call_568257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568257.url(scheme.get, call_568257.host, call_568257.base,
                         call_568257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568257, url, valid)

proc call*(call_568258: Call_JobCollectionsDisable_568250;
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
  var path_568259 = newJObject()
  var query_568260 = newJObject()
  add(path_568259, "resourceGroupName", newJString(resourceGroupName))
  add(query_568260, "api-version", newJString(apiVersion))
  add(path_568259, "subscriptionId", newJString(subscriptionId))
  add(path_568259, "jobCollectionName", newJString(jobCollectionName))
  result = call_568258.call(path_568259, query_568260, nil, nil, nil)

var jobCollectionsDisable* = Call_JobCollectionsDisable_568250(
    name: "jobCollectionsDisable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/disable",
    validator: validate_JobCollectionsDisable_568251, base: "",
    url: url_JobCollectionsDisable_568252, schemes: {Scheme.Https})
type
  Call_JobCollectionsEnable_568261 = ref object of OpenApiRestCall_567641
proc url_JobCollectionsEnable_568263(protocol: Scheme; host: string; base: string;
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

proc validate_JobCollectionsEnable_568262(path: JsonNode; query: JsonNode;
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
  var valid_568264 = path.getOrDefault("resourceGroupName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "resourceGroupName", valid_568264
  var valid_568265 = path.getOrDefault("subscriptionId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "subscriptionId", valid_568265
  var valid_568266 = path.getOrDefault("jobCollectionName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "jobCollectionName", valid_568266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_568268: Call_JobCollectionsEnable_568261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables all of the jobs in the job collection.
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_JobCollectionsEnable_568261;
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
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  add(path_568270, "resourceGroupName", newJString(resourceGroupName))
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "subscriptionId", newJString(subscriptionId))
  add(path_568270, "jobCollectionName", newJString(jobCollectionName))
  result = call_568269.call(path_568270, query_568271, nil, nil, nil)

var jobCollectionsEnable* = Call_JobCollectionsEnable_568261(
    name: "jobCollectionsEnable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/enable",
    validator: validate_JobCollectionsEnable_568262, base: "",
    url: url_JobCollectionsEnable_568263, schemes: {Scheme.Https})
type
  Call_JobsList_568272 = ref object of OpenApiRestCall_567641
proc url_JobsList_568274(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsList_568273(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568276 = path.getOrDefault("resourceGroupName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "resourceGroupName", valid_568276
  var valid_568277 = path.getOrDefault("subscriptionId")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "subscriptionId", valid_568277
  var valid_568278 = path.getOrDefault("jobCollectionName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "jobCollectionName", valid_568278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of jobs to request, in the of range [1..100].
  ##   $skip: JInt
  ##        : The (0-based) index of the job history list from which to begin requesting entries.
  ##   $filter: JString
  ##          : The filter to apply on the job state.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568279 = query.getOrDefault("api-version")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "api-version", valid_568279
  var valid_568280 = query.getOrDefault("$top")
  valid_568280 = validateParameter(valid_568280, JInt, required = false, default = nil)
  if valid_568280 != nil:
    section.add "$top", valid_568280
  var valid_568281 = query.getOrDefault("$skip")
  valid_568281 = validateParameter(valid_568281, JInt, required = false, default = nil)
  if valid_568281 != nil:
    section.add "$skip", valid_568281
  var valid_568282 = query.getOrDefault("$filter")
  valid_568282 = validateParameter(valid_568282, JString, required = false,
                                 default = nil)
  if valid_568282 != nil:
    section.add "$filter", valid_568282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568283: Call_JobsList_568272; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all jobs under the specified job collection.
  ## 
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_JobsList_568272; resourceGroupName: string;
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
  ##      : The number of jobs to request, in the of range [1..100].
  ##   Skip: int
  ##       : The (0-based) index of the job history list from which to begin requesting entries.
  ##   jobCollectionName: string (required)
  ##                    : The job collection name.
  ##   Filter: string
  ##         : The filter to apply on the job state.
  var path_568285 = newJObject()
  var query_568286 = newJObject()
  add(path_568285, "resourceGroupName", newJString(resourceGroupName))
  add(query_568286, "api-version", newJString(apiVersion))
  add(path_568285, "subscriptionId", newJString(subscriptionId))
  add(query_568286, "$top", newJInt(Top))
  add(query_568286, "$skip", newJInt(Skip))
  add(path_568285, "jobCollectionName", newJString(jobCollectionName))
  add(query_568286, "$filter", newJString(Filter))
  result = call_568284.call(path_568285, query_568286, nil, nil, nil)

var jobsList* = Call_JobsList_568272(name: "jobsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/jobs",
                                  validator: validate_JobsList_568273, base: "",
                                  url: url_JobsList_568274,
                                  schemes: {Scheme.Https})
type
  Call_JobsCreateOrUpdate_568299 = ref object of OpenApiRestCall_567641
proc url_JobsCreateOrUpdate_568301(protocol: Scheme; host: string; base: string;
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

proc validate_JobsCreateOrUpdate_568300(path: JsonNode; query: JsonNode;
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
  var valid_568302 = path.getOrDefault("resourceGroupName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "resourceGroupName", valid_568302
  var valid_568303 = path.getOrDefault("subscriptionId")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "subscriptionId", valid_568303
  var valid_568304 = path.getOrDefault("jobName")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "jobName", valid_568304
  var valid_568305 = path.getOrDefault("jobCollectionName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "jobCollectionName", valid_568305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568306 = query.getOrDefault("api-version")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "api-version", valid_568306
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

proc call*(call_568308: Call_JobsCreateOrUpdate_568299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions a new job or updates an existing job.
  ## 
  let valid = call_568308.validator(path, query, header, formData, body)
  let scheme = call_568308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568308.url(scheme.get, call_568308.host, call_568308.base,
                         call_568308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568308, url, valid)

proc call*(call_568309: Call_JobsCreateOrUpdate_568299; resourceGroupName: string;
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
  var path_568310 = newJObject()
  var query_568311 = newJObject()
  var body_568312 = newJObject()
  add(path_568310, "resourceGroupName", newJString(resourceGroupName))
  add(query_568311, "api-version", newJString(apiVersion))
  if job != nil:
    body_568312 = job
  add(path_568310, "subscriptionId", newJString(subscriptionId))
  add(path_568310, "jobName", newJString(jobName))
  add(path_568310, "jobCollectionName", newJString(jobCollectionName))
  result = call_568309.call(path_568310, query_568311, nil, nil, body_568312)

var jobsCreateOrUpdate* = Call_JobsCreateOrUpdate_568299(
    name: "jobsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/jobs/{jobName}",
    validator: validate_JobsCreateOrUpdate_568300, base: "",
    url: url_JobsCreateOrUpdate_568301, schemes: {Scheme.Https})
type
  Call_JobsGet_568287 = ref object of OpenApiRestCall_567641
proc url_JobsGet_568289(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_568288(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568290 = path.getOrDefault("resourceGroupName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "resourceGroupName", valid_568290
  var valid_568291 = path.getOrDefault("subscriptionId")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "subscriptionId", valid_568291
  var valid_568292 = path.getOrDefault("jobName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "jobName", valid_568292
  var valid_568293 = path.getOrDefault("jobCollectionName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "jobCollectionName", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_568295: Call_JobsGet_568287; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job.
  ## 
  let valid = call_568295.validator(path, query, header, formData, body)
  let scheme = call_568295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568295.url(scheme.get, call_568295.host, call_568295.base,
                         call_568295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568295, url, valid)

proc call*(call_568296: Call_JobsGet_568287; resourceGroupName: string;
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
  var path_568297 = newJObject()
  var query_568298 = newJObject()
  add(path_568297, "resourceGroupName", newJString(resourceGroupName))
  add(query_568298, "api-version", newJString(apiVersion))
  add(path_568297, "subscriptionId", newJString(subscriptionId))
  add(path_568297, "jobName", newJString(jobName))
  add(path_568297, "jobCollectionName", newJString(jobCollectionName))
  result = call_568296.call(path_568297, query_568298, nil, nil, nil)

var jobsGet* = Call_JobsGet_568287(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/jobs/{jobName}",
                                validator: validate_JobsGet_568288, base: "",
                                url: url_JobsGet_568289, schemes: {Scheme.Https})
type
  Call_JobsPatch_568325 = ref object of OpenApiRestCall_567641
proc url_JobsPatch_568327(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsPatch_568326(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568328 = path.getOrDefault("resourceGroupName")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "resourceGroupName", valid_568328
  var valid_568329 = path.getOrDefault("subscriptionId")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "subscriptionId", valid_568329
  var valid_568330 = path.getOrDefault("jobName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "jobName", valid_568330
  var valid_568331 = path.getOrDefault("jobCollectionName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "jobCollectionName", valid_568331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568332 = query.getOrDefault("api-version")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "api-version", valid_568332
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

proc call*(call_568334: Call_JobsPatch_568325; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches an existing job.
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_JobsPatch_568325; resourceGroupName: string;
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
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  var body_568338 = newJObject()
  add(path_568336, "resourceGroupName", newJString(resourceGroupName))
  add(query_568337, "api-version", newJString(apiVersion))
  if job != nil:
    body_568338 = job
  add(path_568336, "subscriptionId", newJString(subscriptionId))
  add(path_568336, "jobName", newJString(jobName))
  add(path_568336, "jobCollectionName", newJString(jobCollectionName))
  result = call_568335.call(path_568336, query_568337, nil, nil, body_568338)

var jobsPatch* = Call_JobsPatch_568325(name: "jobsPatch", meth: HttpMethod.HttpPatch,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/jobs/{jobName}",
                                    validator: validate_JobsPatch_568326,
                                    base: "", url: url_JobsPatch_568327,
                                    schemes: {Scheme.Https})
type
  Call_JobsDelete_568313 = ref object of OpenApiRestCall_567641
proc url_JobsDelete_568315(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsDelete_568314(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568316 = path.getOrDefault("resourceGroupName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "resourceGroupName", valid_568316
  var valid_568317 = path.getOrDefault("subscriptionId")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "subscriptionId", valid_568317
  var valid_568318 = path.getOrDefault("jobName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "jobName", valid_568318
  var valid_568319 = path.getOrDefault("jobCollectionName")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "jobCollectionName", valid_568319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568320 = query.getOrDefault("api-version")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "api-version", valid_568320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568321: Call_JobsDelete_568313; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job.
  ## 
  let valid = call_568321.validator(path, query, header, formData, body)
  let scheme = call_568321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568321.url(scheme.get, call_568321.host, call_568321.base,
                         call_568321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568321, url, valid)

proc call*(call_568322: Call_JobsDelete_568313; resourceGroupName: string;
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
  var path_568323 = newJObject()
  var query_568324 = newJObject()
  add(path_568323, "resourceGroupName", newJString(resourceGroupName))
  add(query_568324, "api-version", newJString(apiVersion))
  add(path_568323, "subscriptionId", newJString(subscriptionId))
  add(path_568323, "jobName", newJString(jobName))
  add(path_568323, "jobCollectionName", newJString(jobCollectionName))
  result = call_568322.call(path_568323, query_568324, nil, nil, nil)

var jobsDelete* = Call_JobsDelete_568313(name: "jobsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/jobs/{jobName}",
                                      validator: validate_JobsDelete_568314,
                                      base: "", url: url_JobsDelete_568315,
                                      schemes: {Scheme.Https})
type
  Call_JobsListJobHistory_568339 = ref object of OpenApiRestCall_567641
proc url_JobsListJobHistory_568341(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListJobHistory_568340(path: JsonNode; query: JsonNode;
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
  var valid_568342 = path.getOrDefault("resourceGroupName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "resourceGroupName", valid_568342
  var valid_568343 = path.getOrDefault("subscriptionId")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "subscriptionId", valid_568343
  var valid_568344 = path.getOrDefault("jobName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "jobName", valid_568344
  var valid_568345 = path.getOrDefault("jobCollectionName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "jobCollectionName", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : the number of job history to request, in the of range [1..100].
  ##   $skip: JInt
  ##        : The (0-based) index of the job history list from which to begin requesting entries.
  ##   $filter: JString
  ##          : The filter to apply on the job state.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568346 = query.getOrDefault("api-version")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "api-version", valid_568346
  var valid_568347 = query.getOrDefault("$top")
  valid_568347 = validateParameter(valid_568347, JInt, required = false, default = nil)
  if valid_568347 != nil:
    section.add "$top", valid_568347
  var valid_568348 = query.getOrDefault("$skip")
  valid_568348 = validateParameter(valid_568348, JInt, required = false, default = nil)
  if valid_568348 != nil:
    section.add "$skip", valid_568348
  var valid_568349 = query.getOrDefault("$filter")
  valid_568349 = validateParameter(valid_568349, JString, required = false,
                                 default = nil)
  if valid_568349 != nil:
    section.add "$filter", valid_568349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568350: Call_JobsListJobHistory_568339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists job history.
  ## 
  let valid = call_568350.validator(path, query, header, formData, body)
  let scheme = call_568350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568350.url(scheme.get, call_568350.host, call_568350.base,
                         call_568350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568350, url, valid)

proc call*(call_568351: Call_JobsListJobHistory_568339; resourceGroupName: string;
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
  ##      : the number of job history to request, in the of range [1..100].
  ##   Skip: int
  ##       : The (0-based) index of the job history list from which to begin requesting entries.
  ##   jobCollectionName: string (required)
  ##                    : The job collection name.
  ##   Filter: string
  ##         : The filter to apply on the job state.
  var path_568352 = newJObject()
  var query_568353 = newJObject()
  add(path_568352, "resourceGroupName", newJString(resourceGroupName))
  add(query_568353, "api-version", newJString(apiVersion))
  add(path_568352, "subscriptionId", newJString(subscriptionId))
  add(path_568352, "jobName", newJString(jobName))
  add(query_568353, "$top", newJInt(Top))
  add(query_568353, "$skip", newJInt(Skip))
  add(path_568352, "jobCollectionName", newJString(jobCollectionName))
  add(query_568353, "$filter", newJString(Filter))
  result = call_568351.call(path_568352, query_568353, nil, nil, nil)

var jobsListJobHistory* = Call_JobsListJobHistory_568339(
    name: "jobsListJobHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/jobs/{jobName}/history",
    validator: validate_JobsListJobHistory_568340, base: "",
    url: url_JobsListJobHistory_568341, schemes: {Scheme.Https})
type
  Call_JobsRun_568354 = ref object of OpenApiRestCall_567641
proc url_JobsRun_568356(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsRun_568355(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568357 = path.getOrDefault("resourceGroupName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "resourceGroupName", valid_568357
  var valid_568358 = path.getOrDefault("subscriptionId")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "subscriptionId", valid_568358
  var valid_568359 = path.getOrDefault("jobName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "jobName", valid_568359
  var valid_568360 = path.getOrDefault("jobCollectionName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "jobCollectionName", valid_568360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568361 = query.getOrDefault("api-version")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "api-version", valid_568361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568362: Call_JobsRun_568354; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a job.
  ## 
  let valid = call_568362.validator(path, query, header, formData, body)
  let scheme = call_568362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568362.url(scheme.get, call_568362.host, call_568362.base,
                         call_568362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568362, url, valid)

proc call*(call_568363: Call_JobsRun_568354; resourceGroupName: string;
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
  var path_568364 = newJObject()
  var query_568365 = newJObject()
  add(path_568364, "resourceGroupName", newJString(resourceGroupName))
  add(query_568365, "api-version", newJString(apiVersion))
  add(path_568364, "subscriptionId", newJString(subscriptionId))
  add(path_568364, "jobName", newJString(jobName))
  add(path_568364, "jobCollectionName", newJString(jobCollectionName))
  result = call_568363.call(path_568364, query_568365, nil, nil, nil)

var jobsRun* = Call_JobsRun_568354(name: "jobsRun", meth: HttpMethod.HttpPost,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Scheduler/jobCollections/{jobCollectionName}/jobs/{jobName}/run",
                                validator: validate_JobsRun_568355, base: "",
                                url: url_JobsRun_568356, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
