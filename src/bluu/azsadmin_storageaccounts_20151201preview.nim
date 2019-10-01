
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_574457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574457): Option[Scheme] {.used.} =
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
  Call_StorageAccountsList_574679 = ref object of OpenApiRestCall_574457
proc url_StorageAccountsList_574681(protocol: Scheme; host: string; base: string;
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

proc validate_StorageAccountsList_574680(path: JsonNode; query: JsonNode;
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
  var valid_574854 = path.getOrDefault("resourceGroupName")
  valid_574854 = validateParameter(valid_574854, JString, required = true,
                                 default = nil)
  if valid_574854 != nil:
    section.add "resourceGroupName", valid_574854
  var valid_574855 = path.getOrDefault("farmId")
  valid_574855 = validateParameter(valid_574855, JString, required = true,
                                 default = nil)
  if valid_574855 != nil:
    section.add "farmId", valid_574855
  var valid_574856 = path.getOrDefault("subscriptionId")
  valid_574856 = validateParameter(valid_574856, JString, required = true,
                                 default = nil)
  if valid_574856 != nil:
    section.add "subscriptionId", valid_574856
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  ##   summary: JBool (required)
  ##          : Switch for whether summary or detailed information is returned.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574857 = query.getOrDefault("api-version")
  valid_574857 = validateParameter(valid_574857, JString, required = true,
                                 default = nil)
  if valid_574857 != nil:
    section.add "api-version", valid_574857
  var valid_574858 = query.getOrDefault("summary")
  valid_574858 = validateParameter(valid_574858, JBool, required = true, default = nil)
  if valid_574858 != nil:
    section.add "summary", valid_574858
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574881: Call_StorageAccountsList_574679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of storage accounts.
  ## 
  let valid = call_574881.validator(path, query, header, formData, body)
  let scheme = call_574881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574881.url(scheme.get, call_574881.host, call_574881.base,
                         call_574881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574881, url, valid)

proc call*(call_574952: Call_StorageAccountsList_574679; resourceGroupName: string;
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
  var path_574953 = newJObject()
  var query_574955 = newJObject()
  add(path_574953, "resourceGroupName", newJString(resourceGroupName))
  add(query_574955, "api-version", newJString(apiVersion))
  add(path_574953, "farmId", newJString(farmId))
  add(path_574953, "subscriptionId", newJString(subscriptionId))
  add(query_574955, "summary", newJBool(summary))
  result = call_574952.call(path_574953, query_574955, nil, nil, nil)

var storageAccountsList* = Call_StorageAccountsList_574679(
    name: "storageAccountsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/storageaccounts",
    validator: validate_StorageAccountsList_574680, base: "",
    url: url_StorageAccountsList_574681, schemes: {Scheme.Https})
type
  Call_StorageAccountsUndelete_575006 = ref object of OpenApiRestCall_574457
proc url_StorageAccountsUndelete_575008(protocol: Scheme; host: string; base: string;
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

proc validate_StorageAccountsUndelete_575007(path: JsonNode; query: JsonNode;
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
  var valid_575009 = path.getOrDefault("resourceGroupName")
  valid_575009 = validateParameter(valid_575009, JString, required = true,
                                 default = nil)
  if valid_575009 != nil:
    section.add "resourceGroupName", valid_575009
  var valid_575010 = path.getOrDefault("farmId")
  valid_575010 = validateParameter(valid_575010, JString, required = true,
                                 default = nil)
  if valid_575010 != nil:
    section.add "farmId", valid_575010
  var valid_575011 = path.getOrDefault("subscriptionId")
  valid_575011 = validateParameter(valid_575011, JString, required = true,
                                 default = nil)
  if valid_575011 != nil:
    section.add "subscriptionId", valid_575011
  var valid_575012 = path.getOrDefault("accountId")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = nil)
  if valid_575012 != nil:
    section.add "accountId", valid_575012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575013 = query.getOrDefault("api-version")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "api-version", valid_575013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575014: Call_StorageAccountsUndelete_575006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undelete a deleted storage account.
  ## 
  let valid = call_575014.validator(path, query, header, formData, body)
  let scheme = call_575014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575014.url(scheme.get, call_575014.host, call_575014.base,
                         call_575014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575014, url, valid)

proc call*(call_575015: Call_StorageAccountsUndelete_575006;
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
  var path_575016 = newJObject()
  var query_575017 = newJObject()
  add(path_575016, "resourceGroupName", newJString(resourceGroupName))
  add(query_575017, "api-version", newJString(apiVersion))
  add(path_575016, "farmId", newJString(farmId))
  add(path_575016, "subscriptionId", newJString(subscriptionId))
  add(path_575016, "accountId", newJString(accountId))
  result = call_575015.call(path_575016, query_575017, nil, nil, nil)

var storageAccountsUndelete* = Call_StorageAccountsUndelete_575006(
    name: "storageAccountsUndelete", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/storageaccounts/{accountId}",
    validator: validate_StorageAccountsUndelete_575007, base: "",
    url: url_StorageAccountsUndelete_575008, schemes: {Scheme.Https})
type
  Call_StorageAccountsGet_574994 = ref object of OpenApiRestCall_574457
proc url_StorageAccountsGet_574996(protocol: Scheme; host: string; base: string;
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

proc validate_StorageAccountsGet_574995(path: JsonNode; query: JsonNode;
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
  var valid_574997 = path.getOrDefault("resourceGroupName")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = nil)
  if valid_574997 != nil:
    section.add "resourceGroupName", valid_574997
  var valid_574998 = path.getOrDefault("farmId")
  valid_574998 = validateParameter(valid_574998, JString, required = true,
                                 default = nil)
  if valid_574998 != nil:
    section.add "farmId", valid_574998
  var valid_574999 = path.getOrDefault("subscriptionId")
  valid_574999 = validateParameter(valid_574999, JString, required = true,
                                 default = nil)
  if valid_574999 != nil:
    section.add "subscriptionId", valid_574999
  var valid_575000 = path.getOrDefault("accountId")
  valid_575000 = validateParameter(valid_575000, JString, required = true,
                                 default = nil)
  if valid_575000 != nil:
    section.add "accountId", valid_575000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575001 = query.getOrDefault("api-version")
  valid_575001 = validateParameter(valid_575001, JString, required = true,
                                 default = nil)
  if valid_575001 != nil:
    section.add "api-version", valid_575001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575002: Call_StorageAccountsGet_574994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested storage account.
  ## 
  let valid = call_575002.validator(path, query, header, formData, body)
  let scheme = call_575002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575002.url(scheme.get, call_575002.host, call_575002.base,
                         call_575002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575002, url, valid)

proc call*(call_575003: Call_StorageAccountsGet_574994; resourceGroupName: string;
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
  var path_575004 = newJObject()
  var query_575005 = newJObject()
  add(path_575004, "resourceGroupName", newJString(resourceGroupName))
  add(query_575005, "api-version", newJString(apiVersion))
  add(path_575004, "farmId", newJString(farmId))
  add(path_575004, "subscriptionId", newJString(subscriptionId))
  add(path_575004, "accountId", newJString(accountId))
  result = call_575003.call(path_575004, query_575005, nil, nil, nil)

var storageAccountsGet* = Call_StorageAccountsGet_574994(
    name: "storageAccountsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/storageaccounts/{accountId}",
    validator: validate_StorageAccountsGet_574995, base: "",
    url: url_StorageAccountsGet_574996, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
