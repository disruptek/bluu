
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-storageaccounts"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StorageAccountsReclaimStorageCapacity_563761 = ref object of OpenApiRestCall_563539
proc url_StorageAccountsReclaimStorageCapacity_563763(protocol: Scheme;
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

proc validate_StorageAccountsReclaimStorageCapacity_563762(path: JsonNode;
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
  var valid_563925 = path.getOrDefault("subscriptionId")
  valid_563925 = validateParameter(valid_563925, JString, required = true,
                                 default = nil)
  if valid_563925 != nil:
    section.add "subscriptionId", valid_563925
  var valid_563926 = path.getOrDefault("location")
  valid_563926 = validateParameter(valid_563926, JString, required = true,
                                 default = nil)
  if valid_563926 != nil:
    section.add "location", valid_563926
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563927 = query.getOrDefault("api-version")
  valid_563927 = validateParameter(valid_563927, JString, required = true,
                                 default = nil)
  if valid_563927 != nil:
    section.add "api-version", valid_563927
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563954: Call_StorageAccountsReclaimStorageCapacity_563761;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start reclaim storage capacity on deleted storage objects.
  ## 
  let valid = call_563954.validator(path, query, header, formData, body)
  let scheme = call_563954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563954.url(scheme.get, call_563954.host, call_563954.base,
                         call_563954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563954, url, valid)

proc call*(call_564025: Call_StorageAccountsReclaimStorageCapacity_563761;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## storageAccountsReclaimStorageCapacity
  ## Start reclaim storage capacity on deleted storage objects.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   location: string (required)
  ##           : Resource location.
  var path_564026 = newJObject()
  var query_564028 = newJObject()
  add(query_564028, "api-version", newJString(apiVersion))
  add(path_564026, "subscriptionId", newJString(subscriptionId))
  add(path_564026, "location", newJString(location))
  result = call_564025.call(path_564026, query_564028, nil, nil, nil)

var storageAccountsReclaimStorageCapacity* = Call_StorageAccountsReclaimStorageCapacity_563761(
    name: "storageAccountsReclaimStorageCapacity", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage.Admin/locations/{location}/reclaimStorageCapacity",
    validator: validate_StorageAccountsReclaimStorageCapacity_563762, base: "",
    url: url_StorageAccountsReclaimStorageCapacity_563763, schemes: {Scheme.Https})
type
  Call_StorageAccountsList_564067 = ref object of OpenApiRestCall_563539
proc url_StorageAccountsList_564069(protocol: Scheme; host: string; base: string;
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

proc validate_StorageAccountsList_564068(path: JsonNode; query: JsonNode;
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
  var valid_564080 = path.getOrDefault("subscriptionId")
  valid_564080 = validateParameter(valid_564080, JString, required = true,
                                 default = nil)
  if valid_564080 != nil:
    section.add "subscriptionId", valid_564080
  var valid_564081 = path.getOrDefault("location")
  valid_564081 = validateParameter(valid_564081, JString, required = true,
                                 default = nil)
  if valid_564081 != nil:
    section.add "location", valid_564081
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
  var valid_564082 = query.getOrDefault("api-version")
  valid_564082 = validateParameter(valid_564082, JString, required = true,
                                 default = nil)
  if valid_564082 != nil:
    section.add "api-version", valid_564082
  var valid_564083 = query.getOrDefault("summary")
  valid_564083 = validateParameter(valid_564083, JBool, required = false, default = nil)
  if valid_564083 != nil:
    section.add "summary", valid_564083
  var valid_564084 = query.getOrDefault("$filter")
  valid_564084 = validateParameter(valid_564084, JString, required = false,
                                 default = nil)
  if valid_564084 != nil:
    section.add "$filter", valid_564084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564085: Call_StorageAccountsList_564067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of storage accounts.
  ## 
  let valid = call_564085.validator(path, query, header, formData, body)
  let scheme = call_564085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564085.url(scheme.get, call_564085.host, call_564085.base,
                         call_564085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564085, url, valid)

proc call*(call_564086: Call_StorageAccountsList_564067; apiVersion: string;
          subscriptionId: string; location: string; summary: bool = false;
          Filter: string = ""): Recallable =
  ## storageAccountsList
  ## Returns a list of storage accounts.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   summary: bool
  ##          : Switch for whether summary or detailed information is returned.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   location: string (required)
  ##           : Resource location.
  ##   Filter: string
  ##         : Filter string
  var path_564087 = newJObject()
  var query_564088 = newJObject()
  add(query_564088, "api-version", newJString(apiVersion))
  add(query_564088, "summary", newJBool(summary))
  add(path_564087, "subscriptionId", newJString(subscriptionId))
  add(path_564087, "location", newJString(location))
  add(query_564088, "$filter", newJString(Filter))
  result = call_564086.call(path_564087, query_564088, nil, nil, nil)

var storageAccountsList* = Call_StorageAccountsList_564067(
    name: "storageAccountsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage.Admin/locations/{location}/storageaccounts",
    validator: validate_StorageAccountsList_564068, base: "",
    url: url_StorageAccountsList_564069, schemes: {Scheme.Https})
type
  Call_StorageAccountsGet_564089 = ref object of OpenApiRestCall_563539
proc url_StorageAccountsGet_564091(protocol: Scheme; host: string; base: string;
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

proc validate_StorageAccountsGet_564090(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns the requested storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   location: JString (required)
  ##           : Resource location.
  ##   accountId: JString (required)
  ##            : Internal storage account ID, which is not visible to tenant.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564092 = path.getOrDefault("subscriptionId")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "subscriptionId", valid_564092
  var valid_564093 = path.getOrDefault("location")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "location", valid_564093
  var valid_564094 = path.getOrDefault("accountId")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "accountId", valid_564094
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564095 = query.getOrDefault("api-version")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "api-version", valid_564095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564096: Call_StorageAccountsGet_564089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested storage account.
  ## 
  let valid = call_564096.validator(path, query, header, formData, body)
  let scheme = call_564096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564096.url(scheme.get, call_564096.host, call_564096.base,
                         call_564096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564096, url, valid)

proc call*(call_564097: Call_StorageAccountsGet_564089; apiVersion: string;
          subscriptionId: string; location: string; accountId: string): Recallable =
  ## storageAccountsGet
  ## Returns the requested storage account.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   location: string (required)
  ##           : Resource location.
  ##   accountId: string (required)
  ##            : Internal storage account ID, which is not visible to tenant.
  var path_564098 = newJObject()
  var query_564099 = newJObject()
  add(query_564099, "api-version", newJString(apiVersion))
  add(path_564098, "subscriptionId", newJString(subscriptionId))
  add(path_564098, "location", newJString(location))
  add(path_564098, "accountId", newJString(accountId))
  result = call_564097.call(path_564098, query_564099, nil, nil, nil)

var storageAccountsGet* = Call_StorageAccountsGet_564089(
    name: "storageAccountsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage.Admin/locations/{location}/storageaccounts/{accountId}",
    validator: validate_StorageAccountsGet_564090, base: "",
    url: url_StorageAccountsGet_564091, schemes: {Scheme.Https})
type
  Call_StorageAccountsUndelete_564100 = ref object of OpenApiRestCall_563539
proc url_StorageAccountsUndelete_564102(protocol: Scheme; host: string; base: string;
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

proc validate_StorageAccountsUndelete_564101(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Undelete a deleted storage account with new account name if the a new name is provided.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   location: JString (required)
  ##           : Resource location.
  ##   accountId: JString (required)
  ##            : Internal storage account ID, which is not visible to tenant.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564103 = path.getOrDefault("subscriptionId")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "subscriptionId", valid_564103
  var valid_564104 = path.getOrDefault("location")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "location", valid_564104
  var valid_564105 = path.getOrDefault("accountId")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "accountId", valid_564105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  ##   newAccountName: JString
  ##                 : New storage account name when doing undelete storage account operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564106 = query.getOrDefault("api-version")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "api-version", valid_564106
  var valid_564107 = query.getOrDefault("newAccountName")
  valid_564107 = validateParameter(valid_564107, JString, required = false,
                                 default = nil)
  if valid_564107 != nil:
    section.add "newAccountName", valid_564107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_StorageAccountsUndelete_564100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undelete a deleted storage account with new account name if the a new name is provided.
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_StorageAccountsUndelete_564100; apiVersion: string;
          subscriptionId: string; location: string; accountId: string;
          newAccountName: string = ""): Recallable =
  ## storageAccountsUndelete
  ## Undelete a deleted storage account with new account name if the a new name is provided.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   location: string (required)
  ##           : Resource location.
  ##   accountId: string (required)
  ##            : Internal storage account ID, which is not visible to tenant.
  ##   newAccountName: string
  ##                 : New storage account name when doing undelete storage account operation.
  var path_564110 = newJObject()
  var query_564111 = newJObject()
  add(query_564111, "api-version", newJString(apiVersion))
  add(path_564110, "subscriptionId", newJString(subscriptionId))
  add(path_564110, "location", newJString(location))
  add(path_564110, "accountId", newJString(accountId))
  add(query_564111, "newAccountName", newJString(newAccountName))
  result = call_564109.call(path_564110, query_564111, nil, nil, nil)

var storageAccountsUndelete* = Call_StorageAccountsUndelete_564100(
    name: "storageAccountsUndelete", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage.Admin/locations/{location}/storageaccounts/{accountId}/undelete",
    validator: validate_StorageAccountsUndelete_564101, base: "",
    url: url_StorageAccountsUndelete_564102, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
