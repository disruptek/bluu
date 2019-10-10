
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

  OpenApiRestCall_573641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573641): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-storageaccounts"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StorageAccountsReclaimStorageCapacity_573863 = ref object of OpenApiRestCall_573641
proc url_StorageAccountsReclaimStorageCapacity_573865(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/reclaimStorageCapacity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsReclaimStorageCapacity_573864(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Start reclaim storage capacity on deleted storage objects.
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
  var valid_574025 = path.getOrDefault("subscriptionId")
  valid_574025 = validateParameter(valid_574025, JString, required = true,
                                 default = nil)
  if valid_574025 != nil:
    section.add "subscriptionId", valid_574025
  var valid_574026 = path.getOrDefault("location")
  valid_574026 = validateParameter(valid_574026, JString, required = true,
                                 default = nil)
  if valid_574026 != nil:
    section.add "location", valid_574026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574027 = query.getOrDefault("api-version")
  valid_574027 = validateParameter(valid_574027, JString, required = true,
                                 default = nil)
  if valid_574027 != nil:
    section.add "api-version", valid_574027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574054: Call_StorageAccountsReclaimStorageCapacity_573863;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start reclaim storage capacity on deleted storage objects.
  ## 
  let valid = call_574054.validator(path, query, header, formData, body)
  let scheme = call_574054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574054.url(scheme.get, call_574054.host, call_574054.base,
                         call_574054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574054, url, valid)

proc call*(call_574125: Call_StorageAccountsReclaimStorageCapacity_573863;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## storageAccountsReclaimStorageCapacity
  ## Start reclaim storage capacity on deleted storage objects.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   location: string (required)
  ##           : Resource location.
  var path_574126 = newJObject()
  var query_574128 = newJObject()
  add(query_574128, "api-version", newJString(apiVersion))
  add(path_574126, "subscriptionId", newJString(subscriptionId))
  add(path_574126, "location", newJString(location))
  result = call_574125.call(path_574126, query_574128, nil, nil, nil)

var storageAccountsReclaimStorageCapacity* = Call_StorageAccountsReclaimStorageCapacity_573863(
    name: "storageAccountsReclaimStorageCapacity", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage.Admin/locations/{location}/reclaimStorageCapacity",
    validator: validate_StorageAccountsReclaimStorageCapacity_573864, base: "",
    url: url_StorageAccountsReclaimStorageCapacity_573865, schemes: {Scheme.Https})
type
  Call_StorageAccountsList_574167 = ref object of OpenApiRestCall_573641
proc url_StorageAccountsList_574169(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/storageaccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsList_574168(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a list of storage accounts.
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
  var valid_574180 = path.getOrDefault("subscriptionId")
  valid_574180 = validateParameter(valid_574180, JString, required = true,
                                 default = nil)
  if valid_574180 != nil:
    section.add "subscriptionId", valid_574180
  var valid_574181 = path.getOrDefault("location")
  valid_574181 = validateParameter(valid_574181, JString, required = true,
                                 default = nil)
  if valid_574181 != nil:
    section.add "location", valid_574181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  ##   summary: JBool
  ##          : Switch for whether summary or detailed information is returned.
  ##   $filter: JString
  ##          : Filter string
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574182 = query.getOrDefault("api-version")
  valid_574182 = validateParameter(valid_574182, JString, required = true,
                                 default = nil)
  if valid_574182 != nil:
    section.add "api-version", valid_574182
  var valid_574183 = query.getOrDefault("summary")
  valid_574183 = validateParameter(valid_574183, JBool, required = false, default = nil)
  if valid_574183 != nil:
    section.add "summary", valid_574183
  var valid_574184 = query.getOrDefault("$filter")
  valid_574184 = validateParameter(valid_574184, JString, required = false,
                                 default = nil)
  if valid_574184 != nil:
    section.add "$filter", valid_574184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574185: Call_StorageAccountsList_574167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of storage accounts.
  ## 
  let valid = call_574185.validator(path, query, header, formData, body)
  let scheme = call_574185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574185.url(scheme.get, call_574185.host, call_574185.base,
                         call_574185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574185, url, valid)

proc call*(call_574186: Call_StorageAccountsList_574167; apiVersion: string;
          subscriptionId: string; location: string; summary: bool = false;
          Filter: string = ""): Recallable =
  ## storageAccountsList
  ## Returns a list of storage accounts.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   summary: bool
  ##          : Switch for whether summary or detailed information is returned.
  ##   location: string (required)
  ##           : Resource location.
  ##   Filter: string
  ##         : Filter string
  var path_574187 = newJObject()
  var query_574188 = newJObject()
  add(query_574188, "api-version", newJString(apiVersion))
  add(path_574187, "subscriptionId", newJString(subscriptionId))
  add(query_574188, "summary", newJBool(summary))
  add(path_574187, "location", newJString(location))
  add(query_574188, "$filter", newJString(Filter))
  result = call_574186.call(path_574187, query_574188, nil, nil, nil)

var storageAccountsList* = Call_StorageAccountsList_574167(
    name: "storageAccountsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage.Admin/locations/{location}/storageaccounts",
    validator: validate_StorageAccountsList_574168, base: "",
    url: url_StorageAccountsList_574169, schemes: {Scheme.Https})
type
  Call_StorageAccountsGet_574189 = ref object of OpenApiRestCall_573641
proc url_StorageAccountsGet_574191(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/storageaccounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsGet_574190(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns the requested storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   accountId: JString (required)
  ##            : Internal storage account ID, which is not visible to tenant.
  ##   location: JString (required)
  ##           : Resource location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574192 = path.getOrDefault("subscriptionId")
  valid_574192 = validateParameter(valid_574192, JString, required = true,
                                 default = nil)
  if valid_574192 != nil:
    section.add "subscriptionId", valid_574192
  var valid_574193 = path.getOrDefault("accountId")
  valid_574193 = validateParameter(valid_574193, JString, required = true,
                                 default = nil)
  if valid_574193 != nil:
    section.add "accountId", valid_574193
  var valid_574194 = path.getOrDefault("location")
  valid_574194 = validateParameter(valid_574194, JString, required = true,
                                 default = nil)
  if valid_574194 != nil:
    section.add "location", valid_574194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574195 = query.getOrDefault("api-version")
  valid_574195 = validateParameter(valid_574195, JString, required = true,
                                 default = nil)
  if valid_574195 != nil:
    section.add "api-version", valid_574195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574196: Call_StorageAccountsGet_574189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested storage account.
  ## 
  let valid = call_574196.validator(path, query, header, formData, body)
  let scheme = call_574196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574196.url(scheme.get, call_574196.host, call_574196.base,
                         call_574196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574196, url, valid)

proc call*(call_574197: Call_StorageAccountsGet_574189; apiVersion: string;
          subscriptionId: string; accountId: string; location: string): Recallable =
  ## storageAccountsGet
  ## Returns the requested storage account.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   accountId: string (required)
  ##            : Internal storage account ID, which is not visible to tenant.
  ##   location: string (required)
  ##           : Resource location.
  var path_574198 = newJObject()
  var query_574199 = newJObject()
  add(query_574199, "api-version", newJString(apiVersion))
  add(path_574198, "subscriptionId", newJString(subscriptionId))
  add(path_574198, "accountId", newJString(accountId))
  add(path_574198, "location", newJString(location))
  result = call_574197.call(path_574198, query_574199, nil, nil, nil)

var storageAccountsGet* = Call_StorageAccountsGet_574189(
    name: "storageAccountsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage.Admin/locations/{location}/storageaccounts/{accountId}",
    validator: validate_StorageAccountsGet_574190, base: "",
    url: url_StorageAccountsGet_574191, schemes: {Scheme.Https})
type
  Call_StorageAccountsUndelete_574200 = ref object of OpenApiRestCall_573641
proc url_StorageAccountsUndelete_574202(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/storageaccounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/undelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsUndelete_574201(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Undelete a deleted storage account with new account name if the a new name is provided.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   accountId: JString (required)
  ##            : Internal storage account ID, which is not visible to tenant.
  ##   location: JString (required)
  ##           : Resource location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574203 = path.getOrDefault("subscriptionId")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "subscriptionId", valid_574203
  var valid_574204 = path.getOrDefault("accountId")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "accountId", valid_574204
  var valid_574205 = path.getOrDefault("location")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "location", valid_574205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  ##   newAccountName: JString
  ##                 : New storage account name when doing undelete storage account operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574206 = query.getOrDefault("api-version")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = nil)
  if valid_574206 != nil:
    section.add "api-version", valid_574206
  var valid_574207 = query.getOrDefault("newAccountName")
  valid_574207 = validateParameter(valid_574207, JString, required = false,
                                 default = nil)
  if valid_574207 != nil:
    section.add "newAccountName", valid_574207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574208: Call_StorageAccountsUndelete_574200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undelete a deleted storage account with new account name if the a new name is provided.
  ## 
  let valid = call_574208.validator(path, query, header, formData, body)
  let scheme = call_574208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574208.url(scheme.get, call_574208.host, call_574208.base,
                         call_574208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574208, url, valid)

proc call*(call_574209: Call_StorageAccountsUndelete_574200; apiVersion: string;
          subscriptionId: string; accountId: string; location: string;
          newAccountName: string = ""): Recallable =
  ## storageAccountsUndelete
  ## Undelete a deleted storage account with new account name if the a new name is provided.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   newAccountName: string
  ##                 : New storage account name when doing undelete storage account operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   accountId: string (required)
  ##            : Internal storage account ID, which is not visible to tenant.
  ##   location: string (required)
  ##           : Resource location.
  var path_574210 = newJObject()
  var query_574211 = newJObject()
  add(query_574211, "api-version", newJString(apiVersion))
  add(query_574211, "newAccountName", newJString(newAccountName))
  add(path_574210, "subscriptionId", newJString(subscriptionId))
  add(path_574210, "accountId", newJString(accountId))
  add(path_574210, "location", newJString(location))
  result = call_574209.call(path_574210, query_574211, nil, nil, nil)

var storageAccountsUndelete* = Call_StorageAccountsUndelete_574200(
    name: "storageAccountsUndelete", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage.Admin/locations/{location}/storageaccounts/{accountId}/undelete",
    validator: validate_StorageAccountsUndelete_574201, base: "",
    url: url_StorageAccountsUndelete_574202, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
