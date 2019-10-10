
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-quotas"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StorageQuotasList_573879 = ref object of OpenApiRestCall_573657
proc url_StorageQuotasList_573881(protocol: Scheme; host: string; base: string;
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

proc validate_StorageQuotasList_573880(path: JsonNode; query: JsonNode;
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
  var valid_574041 = path.getOrDefault("subscriptionId")
  valid_574041 = validateParameter(valid_574041, JString, required = true,
                                 default = nil)
  if valid_574041 != nil:
    section.add "subscriptionId", valid_574041
  var valid_574042 = path.getOrDefault("location")
  valid_574042 = validateParameter(valid_574042, JString, required = true,
                                 default = nil)
  if valid_574042 != nil:
    section.add "location", valid_574042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574043 = query.getOrDefault("api-version")
  valid_574043 = validateParameter(valid_574043, JString, required = true,
                                 default = nil)
  if valid_574043 != nil:
    section.add "api-version", valid_574043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574070: Call_StorageQuotasList_573879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of storage quotas at the given location.
  ## 
  let valid = call_574070.validator(path, query, header, formData, body)
  let scheme = call_574070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574070.url(scheme.get, call_574070.host, call_574070.base,
                         call_574070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574070, url, valid)

proc call*(call_574141: Call_StorageQuotasList_573879; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## storageQuotasList
  ## Returns a list of storage quotas at the given location.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   location: string (required)
  ##           : Resource location.
  var path_574142 = newJObject()
  var query_574144 = newJObject()
  add(query_574144, "api-version", newJString(apiVersion))
  add(path_574142, "subscriptionId", newJString(subscriptionId))
  add(path_574142, "location", newJString(location))
  result = call_574141.call(path_574142, query_574144, nil, nil, nil)

var storageQuotasList* = Call_StorageQuotasList_573879(name: "storageQuotasList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage.Admin/locations/{location}/quotas",
    validator: validate_StorageQuotasList_573880, base: "",
    url: url_StorageQuotasList_573881, schemes: {Scheme.Https})
type
  Call_StorageQuotasCreateOrUpdate_574203 = ref object of OpenApiRestCall_573657
proc url_StorageQuotasCreateOrUpdate_574205(protocol: Scheme; host: string;
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

proc validate_StorageQuotasCreateOrUpdate_574204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an existing storage quota.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   location: JString (required)
  ##           : Resource location.
  ##   quotaName: JString (required)
  ##            : The name of the storage quota.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574206 = path.getOrDefault("subscriptionId")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = nil)
  if valid_574206 != nil:
    section.add "subscriptionId", valid_574206
  var valid_574207 = path.getOrDefault("location")
  valid_574207 = validateParameter(valid_574207, JString, required = true,
                                 default = nil)
  if valid_574207 != nil:
    section.add "location", valid_574207
  var valid_574208 = path.getOrDefault("quotaName")
  valid_574208 = validateParameter(valid_574208, JString, required = true,
                                 default = nil)
  if valid_574208 != nil:
    section.add "quotaName", valid_574208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574209 = query.getOrDefault("api-version")
  valid_574209 = validateParameter(valid_574209, JString, required = true,
                                 default = nil)
  if valid_574209 != nil:
    section.add "api-version", valid_574209
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

proc call*(call_574211: Call_StorageQuotasCreateOrUpdate_574203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an existing storage quota.
  ## 
  let valid = call_574211.validator(path, query, header, formData, body)
  let scheme = call_574211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574211.url(scheme.get, call_574211.host, call_574211.base,
                         call_574211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574211, url, valid)

proc call*(call_574212: Call_StorageQuotasCreateOrUpdate_574203;
          apiVersion: string; quotaObject: JsonNode; subscriptionId: string;
          location: string; quotaName: string): Recallable =
  ## storageQuotasCreateOrUpdate
  ## Create or update an existing storage quota.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   quotaObject: JObject (required)
  ##              : The properties of quota being created or updated.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   location: string (required)
  ##           : Resource location.
  ##   quotaName: string (required)
  ##            : The name of the storage quota.
  var path_574213 = newJObject()
  var query_574214 = newJObject()
  var body_574215 = newJObject()
  add(query_574214, "api-version", newJString(apiVersion))
  if quotaObject != nil:
    body_574215 = quotaObject
  add(path_574213, "subscriptionId", newJString(subscriptionId))
  add(path_574213, "location", newJString(location))
  add(path_574213, "quotaName", newJString(quotaName))
  result = call_574212.call(path_574213, query_574214, nil, nil, body_574215)

var storageQuotasCreateOrUpdate* = Call_StorageQuotasCreateOrUpdate_574203(
    name: "storageQuotasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage.Admin/locations/{location}/quotas/{quotaName}",
    validator: validate_StorageQuotasCreateOrUpdate_574204, base: "",
    url: url_StorageQuotasCreateOrUpdate_574205, schemes: {Scheme.Https})
type
  Call_StorageQuotasGet_574183 = ref object of OpenApiRestCall_573657
proc url_StorageQuotasGet_574185(protocol: Scheme; host: string; base: string;
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

proc validate_StorageQuotasGet_574184(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns the specified storage quota.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   location: JString (required)
  ##           : Resource location.
  ##   quotaName: JString (required)
  ##            : The name of the storage quota.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574195 = path.getOrDefault("subscriptionId")
  valid_574195 = validateParameter(valid_574195, JString, required = true,
                                 default = nil)
  if valid_574195 != nil:
    section.add "subscriptionId", valid_574195
  var valid_574196 = path.getOrDefault("location")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "location", valid_574196
  var valid_574197 = path.getOrDefault("quotaName")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "quotaName", valid_574197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574198 = query.getOrDefault("api-version")
  valid_574198 = validateParameter(valid_574198, JString, required = true,
                                 default = nil)
  if valid_574198 != nil:
    section.add "api-version", valid_574198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574199: Call_StorageQuotasGet_574183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified storage quota.
  ## 
  let valid = call_574199.validator(path, query, header, formData, body)
  let scheme = call_574199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574199.url(scheme.get, call_574199.host, call_574199.base,
                         call_574199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574199, url, valid)

proc call*(call_574200: Call_StorageQuotasGet_574183; apiVersion: string;
          subscriptionId: string; location: string; quotaName: string): Recallable =
  ## storageQuotasGet
  ## Returns the specified storage quota.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   location: string (required)
  ##           : Resource location.
  ##   quotaName: string (required)
  ##            : The name of the storage quota.
  var path_574201 = newJObject()
  var query_574202 = newJObject()
  add(query_574202, "api-version", newJString(apiVersion))
  add(path_574201, "subscriptionId", newJString(subscriptionId))
  add(path_574201, "location", newJString(location))
  add(path_574201, "quotaName", newJString(quotaName))
  result = call_574200.call(path_574201, query_574202, nil, nil, nil)

var storageQuotasGet* = Call_StorageQuotasGet_574183(name: "storageQuotasGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage.Admin/locations/{location}/quotas/{quotaName}",
    validator: validate_StorageQuotasGet_574184, base: "",
    url: url_StorageQuotasGet_574185, schemes: {Scheme.Https})
type
  Call_StorageQuotasDelete_574216 = ref object of OpenApiRestCall_573657
proc url_StorageQuotasDelete_574218(protocol: Scheme; host: string; base: string;
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

proc validate_StorageQuotasDelete_574217(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Delete an existing quota
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   location: JString (required)
  ##           : Resource location.
  ##   quotaName: JString (required)
  ##            : The name of the storage quota.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574219 = path.getOrDefault("subscriptionId")
  valid_574219 = validateParameter(valid_574219, JString, required = true,
                                 default = nil)
  if valid_574219 != nil:
    section.add "subscriptionId", valid_574219
  var valid_574220 = path.getOrDefault("location")
  valid_574220 = validateParameter(valid_574220, JString, required = true,
                                 default = nil)
  if valid_574220 != nil:
    section.add "location", valid_574220
  var valid_574221 = path.getOrDefault("quotaName")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "quotaName", valid_574221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574222 = query.getOrDefault("api-version")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "api-version", valid_574222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574223: Call_StorageQuotasDelete_574216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing quota
  ## 
  let valid = call_574223.validator(path, query, header, formData, body)
  let scheme = call_574223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574223.url(scheme.get, call_574223.host, call_574223.base,
                         call_574223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574223, url, valid)

proc call*(call_574224: Call_StorageQuotasDelete_574216; apiVersion: string;
          subscriptionId: string; location: string; quotaName: string): Recallable =
  ## storageQuotasDelete
  ## Delete an existing quota
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   location: string (required)
  ##           : Resource location.
  ##   quotaName: string (required)
  ##            : The name of the storage quota.
  var path_574225 = newJObject()
  var query_574226 = newJObject()
  add(query_574226, "api-version", newJString(apiVersion))
  add(path_574225, "subscriptionId", newJString(subscriptionId))
  add(path_574225, "location", newJString(location))
  add(path_574225, "quotaName", newJString(quotaName))
  result = call_574224.call(path_574225, query_574226, nil, nil, nil)

var storageQuotasDelete* = Call_StorageQuotasDelete_574216(
    name: "storageQuotasDelete", meth: HttpMethod.HttpDelete,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage.Admin/locations/{location}/quotas/{quotaName}",
    validator: validate_StorageQuotasDelete_574217, base: "",
    url: url_StorageQuotasDelete_574218, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
