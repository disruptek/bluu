
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: StorageManagementClient
## version: 2015-12-01-preview
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
  macServiceName = "azsadmin-storageaccounts"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StorageAccountsList_573879 = ref object of OpenApiRestCall_573657
proc url_StorageAccountsList_573881(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/storageaccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsList_573880(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a list of storage accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574054 = path.getOrDefault("resourceGroupName")
  valid_574054 = validateParameter(valid_574054, JString, required = true,
                                 default = nil)
  if valid_574054 != nil:
    section.add "resourceGroupName", valid_574054
  var valid_574055 = path.getOrDefault("farmId")
  valid_574055 = validateParameter(valid_574055, JString, required = true,
                                 default = nil)
  if valid_574055 != nil:
    section.add "farmId", valid_574055
  var valid_574056 = path.getOrDefault("subscriptionId")
  valid_574056 = validateParameter(valid_574056, JString, required = true,
                                 default = nil)
  if valid_574056 != nil:
    section.add "subscriptionId", valid_574056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  ##   summary: JBool (required)
  ##          : Switch for whether summary or detailed information is returned.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574057 = query.getOrDefault("api-version")
  valid_574057 = validateParameter(valid_574057, JString, required = true,
                                 default = nil)
  if valid_574057 != nil:
    section.add "api-version", valid_574057
  var valid_574058 = query.getOrDefault("summary")
  valid_574058 = validateParameter(valid_574058, JBool, required = true, default = nil)
  if valid_574058 != nil:
    section.add "summary", valid_574058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574081: Call_StorageAccountsList_573879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of storage accounts.
  ## 
  let valid = call_574081.validator(path, query, header, formData, body)
  let scheme = call_574081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574081.url(scheme.get, call_574081.host, call_574081.base,
                         call_574081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574081, url, valid)

proc call*(call_574152: Call_StorageAccountsList_573879; resourceGroupName: string;
          apiVersion: string; farmId: string; subscriptionId: string; summary: bool): Recallable =
  ## storageAccountsList
  ## Returns a list of storage accounts.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   summary: bool (required)
  ##          : Switch for whether summary or detailed information is returned.
  var path_574153 = newJObject()
  var query_574155 = newJObject()
  add(path_574153, "resourceGroupName", newJString(resourceGroupName))
  add(query_574155, "api-version", newJString(apiVersion))
  add(path_574153, "farmId", newJString(farmId))
  add(path_574153, "subscriptionId", newJString(subscriptionId))
  add(query_574155, "summary", newJBool(summary))
  result = call_574152.call(path_574153, query_574155, nil, nil, nil)

var storageAccountsList* = Call_StorageAccountsList_573879(
    name: "storageAccountsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/storageaccounts",
    validator: validate_StorageAccountsList_573880, base: "",
    url: url_StorageAccountsList_573881, schemes: {Scheme.Https})
type
  Call_StorageAccountsUndelete_574206 = ref object of OpenApiRestCall_573657
proc url_StorageAccountsUndelete_574208(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/storageaccounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsUndelete_574207(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Undelete a deleted storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   accountId: JString (required)
  ##            : Internal storage account ID, which is not visible to tenant.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574209 = path.getOrDefault("resourceGroupName")
  valid_574209 = validateParameter(valid_574209, JString, required = true,
                                 default = nil)
  if valid_574209 != nil:
    section.add "resourceGroupName", valid_574209
  var valid_574210 = path.getOrDefault("farmId")
  valid_574210 = validateParameter(valid_574210, JString, required = true,
                                 default = nil)
  if valid_574210 != nil:
    section.add "farmId", valid_574210
  var valid_574211 = path.getOrDefault("subscriptionId")
  valid_574211 = validateParameter(valid_574211, JString, required = true,
                                 default = nil)
  if valid_574211 != nil:
    section.add "subscriptionId", valid_574211
  var valid_574212 = path.getOrDefault("accountId")
  valid_574212 = validateParameter(valid_574212, JString, required = true,
                                 default = nil)
  if valid_574212 != nil:
    section.add "accountId", valid_574212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574213 = query.getOrDefault("api-version")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "api-version", valid_574213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574214: Call_StorageAccountsUndelete_574206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undelete a deleted storage account.
  ## 
  let valid = call_574214.validator(path, query, header, formData, body)
  let scheme = call_574214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574214.url(scheme.get, call_574214.host, call_574214.base,
                         call_574214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574214, url, valid)

proc call*(call_574215: Call_StorageAccountsUndelete_574206;
          resourceGroupName: string; apiVersion: string; farmId: string;
          subscriptionId: string; accountId: string): Recallable =
  ## storageAccountsUndelete
  ## Undelete a deleted storage account.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   accountId: string (required)
  ##            : Internal storage account ID, which is not visible to tenant.
  var path_574216 = newJObject()
  var query_574217 = newJObject()
  add(path_574216, "resourceGroupName", newJString(resourceGroupName))
  add(query_574217, "api-version", newJString(apiVersion))
  add(path_574216, "farmId", newJString(farmId))
  add(path_574216, "subscriptionId", newJString(subscriptionId))
  add(path_574216, "accountId", newJString(accountId))
  result = call_574215.call(path_574216, query_574217, nil, nil, nil)

var storageAccountsUndelete* = Call_StorageAccountsUndelete_574206(
    name: "storageAccountsUndelete", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/storageaccounts/{accountId}",
    validator: validate_StorageAccountsUndelete_574207, base: "",
    url: url_StorageAccountsUndelete_574208, schemes: {Scheme.Https})
type
  Call_StorageAccountsGet_574194 = ref object of OpenApiRestCall_573657
proc url_StorageAccountsGet_574196(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/storageaccounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsGet_574195(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns the requested storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   accountId: JString (required)
  ##            : Internal storage account ID, which is not visible to tenant.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574197 = path.getOrDefault("resourceGroupName")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "resourceGroupName", valid_574197
  var valid_574198 = path.getOrDefault("farmId")
  valid_574198 = validateParameter(valid_574198, JString, required = true,
                                 default = nil)
  if valid_574198 != nil:
    section.add "farmId", valid_574198
  var valid_574199 = path.getOrDefault("subscriptionId")
  valid_574199 = validateParameter(valid_574199, JString, required = true,
                                 default = nil)
  if valid_574199 != nil:
    section.add "subscriptionId", valid_574199
  var valid_574200 = path.getOrDefault("accountId")
  valid_574200 = validateParameter(valid_574200, JString, required = true,
                                 default = nil)
  if valid_574200 != nil:
    section.add "accountId", valid_574200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574201 = query.getOrDefault("api-version")
  valid_574201 = validateParameter(valid_574201, JString, required = true,
                                 default = nil)
  if valid_574201 != nil:
    section.add "api-version", valid_574201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574202: Call_StorageAccountsGet_574194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested storage account.
  ## 
  let valid = call_574202.validator(path, query, header, formData, body)
  let scheme = call_574202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574202.url(scheme.get, call_574202.host, call_574202.base,
                         call_574202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574202, url, valid)

proc call*(call_574203: Call_StorageAccountsGet_574194; resourceGroupName: string;
          apiVersion: string; farmId: string; subscriptionId: string;
          accountId: string): Recallable =
  ## storageAccountsGet
  ## Returns the requested storage account.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   accountId: string (required)
  ##            : Internal storage account ID, which is not visible to tenant.
  var path_574204 = newJObject()
  var query_574205 = newJObject()
  add(path_574204, "resourceGroupName", newJString(resourceGroupName))
  add(query_574205, "api-version", newJString(apiVersion))
  add(path_574204, "farmId", newJString(farmId))
  add(path_574204, "subscriptionId", newJString(subscriptionId))
  add(path_574204, "accountId", newJString(accountId))
  result = call_574203.call(path_574204, query_574205, nil, nil, nil)

var storageAccountsGet* = Call_StorageAccountsGet_574194(
    name: "storageAccountsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/storageaccounts/{accountId}",
    validator: validate_StorageAccountsGet_574195, base: "",
    url: url_StorageAccountsGet_574196, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
