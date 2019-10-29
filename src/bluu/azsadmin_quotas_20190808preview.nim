
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: StorageManagementClient
## version: 2019-08-08-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Admin Storage Management Client.
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-quotas"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StorageQuotasList_563777 = ref object of OpenApiRestCall_563555
proc url_StorageQuotasList_563779(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/quotas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageQuotasList_563778(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns a list of storage quotas at the given location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   location: JString (required)
  ##           : Resource location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563941 = path.getOrDefault("subscriptionId")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "subscriptionId", valid_563941
  var valid_563942 = path.getOrDefault("location")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "location", valid_563942
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563943 = query.getOrDefault("api-version")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "api-version", valid_563943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563970: Call_StorageQuotasList_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of storage quotas at the given location.
  ## 
  let valid = call_563970.validator(path, query, header, formData, body)
  let scheme = call_563970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563970.url(scheme.get, call_563970.host, call_563970.base,
                         call_563970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563970, url, valid)

proc call*(call_564041: Call_StorageQuotasList_563777; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## storageQuotasList
  ## Returns a list of storage quotas at the given location.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   location: string (required)
  ##           : Resource location.
  var path_564042 = newJObject()
  var query_564044 = newJObject()
  add(query_564044, "api-version", newJString(apiVersion))
  add(path_564042, "subscriptionId", newJString(subscriptionId))
  add(path_564042, "location", newJString(location))
  result = call_564041.call(path_564042, query_564044, nil, nil, nil)

var storageQuotasList* = Call_StorageQuotasList_563777(name: "storageQuotasList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage.Admin/locations/{location}/quotas",
    validator: validate_StorageQuotasList_563778, base: "",
    url: url_StorageQuotasList_563779, schemes: {Scheme.Https})
type
  Call_StorageQuotasCreateOrUpdate_564103 = ref object of OpenApiRestCall_563555
proc url_StorageQuotasCreateOrUpdate_564105(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "quotaName" in path, "`quotaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageQuotasCreateOrUpdate_564104(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an existing storage quota.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaName: JString (required)
  ##            : The name of the storage quota.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   location: JString (required)
  ##           : Resource location.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `quotaName` field"
  var valid_564106 = path.getOrDefault("quotaName")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "quotaName", valid_564106
  var valid_564107 = path.getOrDefault("subscriptionId")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "subscriptionId", valid_564107
  var valid_564108 = path.getOrDefault("location")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "location", valid_564108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564109 = query.getOrDefault("api-version")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "api-version", valid_564109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   quotaObject: JObject (required)
  ##              : The properties of quota being created or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564111: Call_StorageQuotasCreateOrUpdate_564103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an existing storage quota.
  ## 
  let valid = call_564111.validator(path, query, header, formData, body)
  let scheme = call_564111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564111.url(scheme.get, call_564111.host, call_564111.base,
                         call_564111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564111, url, valid)

proc call*(call_564112: Call_StorageQuotasCreateOrUpdate_564103; quotaName: string;
          apiVersion: string; subscriptionId: string; location: string;
          quotaObject: JsonNode): Recallable =
  ## storageQuotasCreateOrUpdate
  ## Create or update an existing storage quota.
  ##   quotaName: string (required)
  ##            : The name of the storage quota.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   location: string (required)
  ##           : Resource location.
  ##   quotaObject: JObject (required)
  ##              : The properties of quota being created or updated.
  var path_564113 = newJObject()
  var query_564114 = newJObject()
  var body_564115 = newJObject()
  add(path_564113, "quotaName", newJString(quotaName))
  add(query_564114, "api-version", newJString(apiVersion))
  add(path_564113, "subscriptionId", newJString(subscriptionId))
  add(path_564113, "location", newJString(location))
  if quotaObject != nil:
    body_564115 = quotaObject
  result = call_564112.call(path_564113, query_564114, nil, nil, body_564115)

var storageQuotasCreateOrUpdate* = Call_StorageQuotasCreateOrUpdate_564103(
    name: "storageQuotasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage.Admin/locations/{location}/quotas/{quotaName}",
    validator: validate_StorageQuotasCreateOrUpdate_564104, base: "",
    url: url_StorageQuotasCreateOrUpdate_564105, schemes: {Scheme.Https})
type
  Call_StorageQuotasGet_564083 = ref object of OpenApiRestCall_563555
proc url_StorageQuotasGet_564085(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "quotaName" in path, "`quotaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageQuotasGet_564084(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns the specified storage quota.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaName: JString (required)
  ##            : The name of the storage quota.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   location: JString (required)
  ##           : Resource location.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `quotaName` field"
  var valid_564095 = path.getOrDefault("quotaName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "quotaName", valid_564095
  var valid_564096 = path.getOrDefault("subscriptionId")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "subscriptionId", valid_564096
  var valid_564097 = path.getOrDefault("location")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "location", valid_564097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564098 = query.getOrDefault("api-version")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "api-version", valid_564098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564099: Call_StorageQuotasGet_564083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified storage quota.
  ## 
  let valid = call_564099.validator(path, query, header, formData, body)
  let scheme = call_564099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564099.url(scheme.get, call_564099.host, call_564099.base,
                         call_564099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564099, url, valid)

proc call*(call_564100: Call_StorageQuotasGet_564083; quotaName: string;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## storageQuotasGet
  ## Returns the specified storage quota.
  ##   quotaName: string (required)
  ##            : The name of the storage quota.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   location: string (required)
  ##           : Resource location.
  var path_564101 = newJObject()
  var query_564102 = newJObject()
  add(path_564101, "quotaName", newJString(quotaName))
  add(query_564102, "api-version", newJString(apiVersion))
  add(path_564101, "subscriptionId", newJString(subscriptionId))
  add(path_564101, "location", newJString(location))
  result = call_564100.call(path_564101, query_564102, nil, nil, nil)

var storageQuotasGet* = Call_StorageQuotasGet_564083(name: "storageQuotasGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage.Admin/locations/{location}/quotas/{quotaName}",
    validator: validate_StorageQuotasGet_564084, base: "",
    url: url_StorageQuotasGet_564085, schemes: {Scheme.Https})
type
  Call_StorageQuotasDelete_564116 = ref object of OpenApiRestCall_563555
proc url_StorageQuotasDelete_564118(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "quotaName" in path, "`quotaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageQuotasDelete_564117(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Delete an existing quota
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaName: JString (required)
  ##            : The name of the storage quota.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   location: JString (required)
  ##           : Resource location.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `quotaName` field"
  var valid_564119 = path.getOrDefault("quotaName")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "quotaName", valid_564119
  var valid_564120 = path.getOrDefault("subscriptionId")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "subscriptionId", valid_564120
  var valid_564121 = path.getOrDefault("location")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "location", valid_564121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564122 = query.getOrDefault("api-version")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "api-version", valid_564122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564123: Call_StorageQuotasDelete_564116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing quota
  ## 
  let valid = call_564123.validator(path, query, header, formData, body)
  let scheme = call_564123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564123.url(scheme.get, call_564123.host, call_564123.base,
                         call_564123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564123, url, valid)

proc call*(call_564124: Call_StorageQuotasDelete_564116; quotaName: string;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## storageQuotasDelete
  ## Delete an existing quota
  ##   quotaName: string (required)
  ##            : The name of the storage quota.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   location: string (required)
  ##           : Resource location.
  var path_564125 = newJObject()
  var query_564126 = newJObject()
  add(path_564125, "quotaName", newJString(quotaName))
  add(query_564126, "api-version", newJString(apiVersion))
  add(path_564125, "subscriptionId", newJString(subscriptionId))
  add(path_564125, "location", newJString(location))
  result = call_564124.call(path_564125, query_564126, nil, nil, nil)

var storageQuotasDelete* = Call_StorageQuotasDelete_564116(
    name: "storageQuotasDelete", meth: HttpMethod.HttpDelete,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage.Admin/locations/{location}/quotas/{quotaName}",
    validator: validate_StorageQuotasDelete_564117, base: "",
    url: url_StorageQuotasDelete_564118, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
