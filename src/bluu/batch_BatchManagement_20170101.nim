
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BatchManagement
## version: 2017-01-01
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
  macServiceName = "batch-BatchManagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BatchAccountList_574679 = ref object of OpenApiRestCall_574457
proc url_BatchAccountList_574681(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountList_574680(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets information about the Batch accounts associated with the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574854 = path.getOrDefault("subscriptionId")
  valid_574854 = validateParameter(valid_574854, JString, required = true,
                                 default = nil)
  if valid_574854 != nil:
    section.add "subscriptionId", valid_574854
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574855 = query.getOrDefault("api-version")
  valid_574855 = validateParameter(valid_574855, JString, required = true,
                                 default = nil)
  if valid_574855 != nil:
    section.add "api-version", valid_574855
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574878: Call_BatchAccountList_574679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the Batch accounts associated with the subscription.
  ## 
  let valid = call_574878.validator(path, query, header, formData, body)
  let scheme = call_574878.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574878.url(scheme.get, call_574878.host, call_574878.base,
                         call_574878.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574878, url, valid)

proc call*(call_574949: Call_BatchAccountList_574679; apiVersion: string;
          subscriptionId: string): Recallable =
  ## batchAccountList
  ## Gets information about the Batch accounts associated with the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574950 = newJObject()
  var query_574952 = newJObject()
  add(query_574952, "api-version", newJString(apiVersion))
  add(path_574950, "subscriptionId", newJString(subscriptionId))
  result = call_574949.call(path_574950, query_574952, nil, nil, nil)

var batchAccountList* = Call_BatchAccountList_574679(name: "batchAccountList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Batch/batchAccounts",
    validator: validate_BatchAccountList_574680, base: "",
    url: url_BatchAccountList_574681, schemes: {Scheme.Https})
type
  Call_LocationGetQuotas_574991 = ref object of OpenApiRestCall_574457
proc url_LocationGetQuotas_574993(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/quotas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationGetQuotas_574992(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the Batch service quotas for the specified subscription at the given location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   locationName: JString (required)
  ##               : The desired region for the quotas.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574994 = path.getOrDefault("subscriptionId")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "subscriptionId", valid_574994
  var valid_574995 = path.getOrDefault("locationName")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "locationName", valid_574995
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574996 = query.getOrDefault("api-version")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "api-version", valid_574996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574997: Call_LocationGetQuotas_574991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Batch service quotas for the specified subscription at the given location.
  ## 
  let valid = call_574997.validator(path, query, header, formData, body)
  let scheme = call_574997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574997.url(scheme.get, call_574997.host, call_574997.base,
                         call_574997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574997, url, valid)

proc call*(call_574998: Call_LocationGetQuotas_574991; apiVersion: string;
          subscriptionId: string; locationName: string): Recallable =
  ## locationGetQuotas
  ## Gets the Batch service quotas for the specified subscription at the given location.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   locationName: string (required)
  ##               : The desired region for the quotas.
  var path_574999 = newJObject()
  var query_575000 = newJObject()
  add(query_575000, "api-version", newJString(apiVersion))
  add(path_574999, "subscriptionId", newJString(subscriptionId))
  add(path_574999, "locationName", newJString(locationName))
  result = call_574998.call(path_574999, query_575000, nil, nil, nil)

var locationGetQuotas* = Call_LocationGetQuotas_574991(name: "locationGetQuotas",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Batch/locations/{locationName}/quotas",
    validator: validate_LocationGetQuotas_574992, base: "",
    url: url_LocationGetQuotas_574993, schemes: {Scheme.Https})
type
  Call_BatchAccountListByResourceGroup_575001 = ref object of OpenApiRestCall_574457
proc url_BatchAccountListByResourceGroup_575003(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountListByResourceGroup_575002(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the Batch accounts associated within the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group whose Batch accounts to list.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575004 = path.getOrDefault("resourceGroupName")
  valid_575004 = validateParameter(valid_575004, JString, required = true,
                                 default = nil)
  if valid_575004 != nil:
    section.add "resourceGroupName", valid_575004
  var valid_575005 = path.getOrDefault("subscriptionId")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = nil)
  if valid_575005 != nil:
    section.add "subscriptionId", valid_575005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575006 = query.getOrDefault("api-version")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = nil)
  if valid_575006 != nil:
    section.add "api-version", valid_575006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575007: Call_BatchAccountListByResourceGroup_575001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the Batch accounts associated within the specified resource group.
  ## 
  let valid = call_575007.validator(path, query, header, formData, body)
  let scheme = call_575007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575007.url(scheme.get, call_575007.host, call_575007.base,
                         call_575007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575007, url, valid)

proc call*(call_575008: Call_BatchAccountListByResourceGroup_575001;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## batchAccountListByResourceGroup
  ## Gets information about the Batch accounts associated within the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group whose Batch accounts to list.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_575009 = newJObject()
  var query_575010 = newJObject()
  add(path_575009, "resourceGroupName", newJString(resourceGroupName))
  add(query_575010, "api-version", newJString(apiVersion))
  add(path_575009, "subscriptionId", newJString(subscriptionId))
  result = call_575008.call(path_575009, query_575010, nil, nil, nil)

var batchAccountListByResourceGroup* = Call_BatchAccountListByResourceGroup_575001(
    name: "batchAccountListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts",
    validator: validate_BatchAccountListByResourceGroup_575002, base: "",
    url: url_BatchAccountListByResourceGroup_575003, schemes: {Scheme.Https})
type
  Call_BatchAccountCreate_575022 = ref object of OpenApiRestCall_574457
proc url_BatchAccountCreate_575024(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountCreate_575023(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a new Batch account with the specified parameters. Existing accounts cannot be updated with this API and should instead be updated with the Update Batch Account API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the new Batch account.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : A name for the Batch account which must be unique within the region. Batch account names must be between 3 and 24 characters in length and must use only numbers and lowercase letters. This name is used as part of the DNS name that is used to access the Batch service in the region in which the account is created. For example: http://accountname.region.batch.azure.com/.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575042 = path.getOrDefault("resourceGroupName")
  valid_575042 = validateParameter(valid_575042, JString, required = true,
                                 default = nil)
  if valid_575042 != nil:
    section.add "resourceGroupName", valid_575042
  var valid_575043 = path.getOrDefault("subscriptionId")
  valid_575043 = validateParameter(valid_575043, JString, required = true,
                                 default = nil)
  if valid_575043 != nil:
    section.add "subscriptionId", valid_575043
  var valid_575044 = path.getOrDefault("accountName")
  valid_575044 = validateParameter(valid_575044, JString, required = true,
                                 default = nil)
  if valid_575044 != nil:
    section.add "accountName", valid_575044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575045 = query.getOrDefault("api-version")
  valid_575045 = validateParameter(valid_575045, JString, required = true,
                                 default = nil)
  if valid_575045 != nil:
    section.add "api-version", valid_575045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters for account creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575047: Call_BatchAccountCreate_575022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Batch account with the specified parameters. Existing accounts cannot be updated with this API and should instead be updated with the Update Batch Account API.
  ## 
  let valid = call_575047.validator(path, query, header, formData, body)
  let scheme = call_575047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575047.url(scheme.get, call_575047.host, call_575047.base,
                         call_575047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575047, url, valid)

proc call*(call_575048: Call_BatchAccountCreate_575022; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## batchAccountCreate
  ## Creates a new Batch account with the specified parameters. Existing accounts cannot be updated with this API and should instead be updated with the Update Batch Account API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the new Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Additional parameters for account creation.
  ##   accountName: string (required)
  ##              : A name for the Batch account which must be unique within the region. Batch account names must be between 3 and 24 characters in length and must use only numbers and lowercase letters. This name is used as part of the DNS name that is used to access the Batch service in the region in which the account is created. For example: http://accountname.region.batch.azure.com/.
  var path_575049 = newJObject()
  var query_575050 = newJObject()
  var body_575051 = newJObject()
  add(path_575049, "resourceGroupName", newJString(resourceGroupName))
  add(query_575050, "api-version", newJString(apiVersion))
  add(path_575049, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575051 = parameters
  add(path_575049, "accountName", newJString(accountName))
  result = call_575048.call(path_575049, query_575050, nil, nil, body_575051)

var batchAccountCreate* = Call_BatchAccountCreate_575022(
    name: "batchAccountCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}",
    validator: validate_BatchAccountCreate_575023, base: "",
    url: url_BatchAccountCreate_575024, schemes: {Scheme.Https})
type
  Call_BatchAccountGet_575011 = ref object of OpenApiRestCall_574457
proc url_BatchAccountGet_575013(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountGet_575012(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets information about the specified Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575014 = path.getOrDefault("resourceGroupName")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "resourceGroupName", valid_575014
  var valid_575015 = path.getOrDefault("subscriptionId")
  valid_575015 = validateParameter(valid_575015, JString, required = true,
                                 default = nil)
  if valid_575015 != nil:
    section.add "subscriptionId", valid_575015
  var valid_575016 = path.getOrDefault("accountName")
  valid_575016 = validateParameter(valid_575016, JString, required = true,
                                 default = nil)
  if valid_575016 != nil:
    section.add "accountName", valid_575016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575017 = query.getOrDefault("api-version")
  valid_575017 = validateParameter(valid_575017, JString, required = true,
                                 default = nil)
  if valid_575017 != nil:
    section.add "api-version", valid_575017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575018: Call_BatchAccountGet_575011; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified Batch account.
  ## 
  let valid = call_575018.validator(path, query, header, formData, body)
  let scheme = call_575018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575018.url(scheme.get, call_575018.host, call_575018.base,
                         call_575018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575018, url, valid)

proc call*(call_575019: Call_BatchAccountGet_575011; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## batchAccountGet
  ## Gets information about the specified Batch account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the account.
  var path_575020 = newJObject()
  var query_575021 = newJObject()
  add(path_575020, "resourceGroupName", newJString(resourceGroupName))
  add(query_575021, "api-version", newJString(apiVersion))
  add(path_575020, "subscriptionId", newJString(subscriptionId))
  add(path_575020, "accountName", newJString(accountName))
  result = call_575019.call(path_575020, query_575021, nil, nil, nil)

var batchAccountGet* = Call_BatchAccountGet_575011(name: "batchAccountGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}",
    validator: validate_BatchAccountGet_575012, base: "", url: url_BatchAccountGet_575013,
    schemes: {Scheme.Https})
type
  Call_BatchAccountUpdate_575063 = ref object of OpenApiRestCall_574457
proc url_BatchAccountUpdate_575065(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountUpdate_575064(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the properties of an existing Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575066 = path.getOrDefault("resourceGroupName")
  valid_575066 = validateParameter(valid_575066, JString, required = true,
                                 default = nil)
  if valid_575066 != nil:
    section.add "resourceGroupName", valid_575066
  var valid_575067 = path.getOrDefault("subscriptionId")
  valid_575067 = validateParameter(valid_575067, JString, required = true,
                                 default = nil)
  if valid_575067 != nil:
    section.add "subscriptionId", valid_575067
  var valid_575068 = path.getOrDefault("accountName")
  valid_575068 = validateParameter(valid_575068, JString, required = true,
                                 default = nil)
  if valid_575068 != nil:
    section.add "accountName", valid_575068
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575069 = query.getOrDefault("api-version")
  valid_575069 = validateParameter(valid_575069, JString, required = true,
                                 default = nil)
  if valid_575069 != nil:
    section.add "api-version", valid_575069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters for account update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575071: Call_BatchAccountUpdate_575063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing Batch account.
  ## 
  let valid = call_575071.validator(path, query, header, formData, body)
  let scheme = call_575071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575071.url(scheme.get, call_575071.host, call_575071.base,
                         call_575071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575071, url, valid)

proc call*(call_575072: Call_BatchAccountUpdate_575063; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## batchAccountUpdate
  ## Updates the properties of an existing Batch account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Additional parameters for account update.
  ##   accountName: string (required)
  ##              : The name of the account.
  var path_575073 = newJObject()
  var query_575074 = newJObject()
  var body_575075 = newJObject()
  add(path_575073, "resourceGroupName", newJString(resourceGroupName))
  add(query_575074, "api-version", newJString(apiVersion))
  add(path_575073, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575075 = parameters
  add(path_575073, "accountName", newJString(accountName))
  result = call_575072.call(path_575073, query_575074, nil, nil, body_575075)

var batchAccountUpdate* = Call_BatchAccountUpdate_575063(
    name: "batchAccountUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}",
    validator: validate_BatchAccountUpdate_575064, base: "",
    url: url_BatchAccountUpdate_575065, schemes: {Scheme.Https})
type
  Call_BatchAccountDelete_575052 = ref object of OpenApiRestCall_574457
proc url_BatchAccountDelete_575054(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountDelete_575053(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the specified Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account to be deleted.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the account to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575055 = path.getOrDefault("resourceGroupName")
  valid_575055 = validateParameter(valid_575055, JString, required = true,
                                 default = nil)
  if valid_575055 != nil:
    section.add "resourceGroupName", valid_575055
  var valid_575056 = path.getOrDefault("subscriptionId")
  valid_575056 = validateParameter(valid_575056, JString, required = true,
                                 default = nil)
  if valid_575056 != nil:
    section.add "subscriptionId", valid_575056
  var valid_575057 = path.getOrDefault("accountName")
  valid_575057 = validateParameter(valid_575057, JString, required = true,
                                 default = nil)
  if valid_575057 != nil:
    section.add "accountName", valid_575057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575058 = query.getOrDefault("api-version")
  valid_575058 = validateParameter(valid_575058, JString, required = true,
                                 default = nil)
  if valid_575058 != nil:
    section.add "api-version", valid_575058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575059: Call_BatchAccountDelete_575052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Batch account.
  ## 
  let valid = call_575059.validator(path, query, header, formData, body)
  let scheme = call_575059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575059.url(scheme.get, call_575059.host, call_575059.base,
                         call_575059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575059, url, valid)

proc call*(call_575060: Call_BatchAccountDelete_575052; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## batchAccountDelete
  ## Deletes the specified Batch account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account to be deleted.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the account to be deleted.
  var path_575061 = newJObject()
  var query_575062 = newJObject()
  add(path_575061, "resourceGroupName", newJString(resourceGroupName))
  add(query_575062, "api-version", newJString(apiVersion))
  add(path_575061, "subscriptionId", newJString(subscriptionId))
  add(path_575061, "accountName", newJString(accountName))
  result = call_575060.call(path_575061, query_575062, nil, nil, nil)

var batchAccountDelete* = Call_BatchAccountDelete_575052(
    name: "batchAccountDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}",
    validator: validate_BatchAccountDelete_575053, base: "",
    url: url_BatchAccountDelete_575054, schemes: {Scheme.Https})
type
  Call_ApplicationList_575076 = ref object of OpenApiRestCall_574457
proc url_ApplicationList_575078(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationList_575077(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists all of the applications in the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575079 = path.getOrDefault("resourceGroupName")
  valid_575079 = validateParameter(valid_575079, JString, required = true,
                                 default = nil)
  if valid_575079 != nil:
    section.add "resourceGroupName", valid_575079
  var valid_575080 = path.getOrDefault("subscriptionId")
  valid_575080 = validateParameter(valid_575080, JString, required = true,
                                 default = nil)
  if valid_575080 != nil:
    section.add "subscriptionId", valid_575080
  var valid_575081 = path.getOrDefault("accountName")
  valid_575081 = validateParameter(valid_575081, JString, required = true,
                                 default = nil)
  if valid_575081 != nil:
    section.add "accountName", valid_575081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575082 = query.getOrDefault("api-version")
  valid_575082 = validateParameter(valid_575082, JString, required = true,
                                 default = nil)
  if valid_575082 != nil:
    section.add "api-version", valid_575082
  var valid_575083 = query.getOrDefault("maxresults")
  valid_575083 = validateParameter(valid_575083, JInt, required = false, default = nil)
  if valid_575083 != nil:
    section.add "maxresults", valid_575083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575084: Call_ApplicationList_575076; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the applications in the specified account.
  ## 
  let valid = call_575084.validator(path, query, header, formData, body)
  let scheme = call_575084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575084.url(scheme.get, call_575084.host, call_575084.base,
                         call_575084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575084, url, valid)

proc call*(call_575085: Call_ApplicationList_575076; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string;
          maxresults: int = 0): Recallable =
  ## applicationList
  ## Lists all of the applications in the specified account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575086 = newJObject()
  var query_575087 = newJObject()
  add(path_575086, "resourceGroupName", newJString(resourceGroupName))
  add(query_575087, "api-version", newJString(apiVersion))
  add(path_575086, "subscriptionId", newJString(subscriptionId))
  add(query_575087, "maxresults", newJInt(maxresults))
  add(path_575086, "accountName", newJString(accountName))
  result = call_575085.call(path_575086, query_575087, nil, nil, nil)

var applicationList* = Call_ApplicationList_575076(name: "applicationList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications",
    validator: validate_ApplicationList_575077, base: "", url: url_ApplicationList_575078,
    schemes: {Scheme.Https})
type
  Call_ApplicationCreate_575100 = ref object of OpenApiRestCall_574457
proc url_ApplicationCreate_575102(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationCreate_575101(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Adds an application to the specified Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationId: JString (required)
  ##                : The ID of the application.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575103 = path.getOrDefault("resourceGroupName")
  valid_575103 = validateParameter(valid_575103, JString, required = true,
                                 default = nil)
  if valid_575103 != nil:
    section.add "resourceGroupName", valid_575103
  var valid_575104 = path.getOrDefault("subscriptionId")
  valid_575104 = validateParameter(valid_575104, JString, required = true,
                                 default = nil)
  if valid_575104 != nil:
    section.add "subscriptionId", valid_575104
  var valid_575105 = path.getOrDefault("applicationId")
  valid_575105 = validateParameter(valid_575105, JString, required = true,
                                 default = nil)
  if valid_575105 != nil:
    section.add "applicationId", valid_575105
  var valid_575106 = path.getOrDefault("accountName")
  valid_575106 = validateParameter(valid_575106, JString, required = true,
                                 default = nil)
  if valid_575106 != nil:
    section.add "accountName", valid_575106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575107 = query.getOrDefault("api-version")
  valid_575107 = validateParameter(valid_575107, JString, required = true,
                                 default = nil)
  if valid_575107 != nil:
    section.add "api-version", valid_575107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575109: Call_ApplicationCreate_575100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an application to the specified Batch account.
  ## 
  let valid = call_575109.validator(path, query, header, formData, body)
  let scheme = call_575109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575109.url(scheme.get, call_575109.host, call_575109.base,
                         call_575109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575109, url, valid)

proc call*(call_575110: Call_ApplicationCreate_575100; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; applicationId: string;
          accountName: string; parameters: JsonNode = nil): Recallable =
  ## applicationCreate
  ## Adds an application to the specified Batch account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationId: string (required)
  ##                : The ID of the application.
  ##   parameters: JObject
  ##             : The parameters for the request.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575111 = newJObject()
  var query_575112 = newJObject()
  var body_575113 = newJObject()
  add(path_575111, "resourceGroupName", newJString(resourceGroupName))
  add(query_575112, "api-version", newJString(apiVersion))
  add(path_575111, "subscriptionId", newJString(subscriptionId))
  add(path_575111, "applicationId", newJString(applicationId))
  if parameters != nil:
    body_575113 = parameters
  add(path_575111, "accountName", newJString(accountName))
  result = call_575110.call(path_575111, query_575112, nil, nil, body_575113)

var applicationCreate* = Call_ApplicationCreate_575100(name: "applicationCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}",
    validator: validate_ApplicationCreate_575101, base: "",
    url: url_ApplicationCreate_575102, schemes: {Scheme.Https})
type
  Call_ApplicationGet_575088 = ref object of OpenApiRestCall_574457
proc url_ApplicationGet_575090(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGet_575089(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about the specified application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationId: JString (required)
  ##                : The ID of the application.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575091 = path.getOrDefault("resourceGroupName")
  valid_575091 = validateParameter(valid_575091, JString, required = true,
                                 default = nil)
  if valid_575091 != nil:
    section.add "resourceGroupName", valid_575091
  var valid_575092 = path.getOrDefault("subscriptionId")
  valid_575092 = validateParameter(valid_575092, JString, required = true,
                                 default = nil)
  if valid_575092 != nil:
    section.add "subscriptionId", valid_575092
  var valid_575093 = path.getOrDefault("applicationId")
  valid_575093 = validateParameter(valid_575093, JString, required = true,
                                 default = nil)
  if valid_575093 != nil:
    section.add "applicationId", valid_575093
  var valid_575094 = path.getOrDefault("accountName")
  valid_575094 = validateParameter(valid_575094, JString, required = true,
                                 default = nil)
  if valid_575094 != nil:
    section.add "accountName", valid_575094
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575095 = query.getOrDefault("api-version")
  valid_575095 = validateParameter(valid_575095, JString, required = true,
                                 default = nil)
  if valid_575095 != nil:
    section.add "api-version", valid_575095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575096: Call_ApplicationGet_575088; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified application.
  ## 
  let valid = call_575096.validator(path, query, header, formData, body)
  let scheme = call_575096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575096.url(scheme.get, call_575096.host, call_575096.base,
                         call_575096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575096, url, valid)

proc call*(call_575097: Call_ApplicationGet_575088; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; applicationId: string;
          accountName: string): Recallable =
  ## applicationGet
  ## Gets information about the specified application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationId: string (required)
  ##                : The ID of the application.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575098 = newJObject()
  var query_575099 = newJObject()
  add(path_575098, "resourceGroupName", newJString(resourceGroupName))
  add(query_575099, "api-version", newJString(apiVersion))
  add(path_575098, "subscriptionId", newJString(subscriptionId))
  add(path_575098, "applicationId", newJString(applicationId))
  add(path_575098, "accountName", newJString(accountName))
  result = call_575097.call(path_575098, query_575099, nil, nil, nil)

var applicationGet* = Call_ApplicationGet_575088(name: "applicationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}",
    validator: validate_ApplicationGet_575089, base: "", url: url_ApplicationGet_575090,
    schemes: {Scheme.Https})
type
  Call_ApplicationUpdate_575126 = ref object of OpenApiRestCall_574457
proc url_ApplicationUpdate_575128(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationUpdate_575127(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates settings for the specified application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationId: JString (required)
  ##                : The ID of the application.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575129 = path.getOrDefault("resourceGroupName")
  valid_575129 = validateParameter(valid_575129, JString, required = true,
                                 default = nil)
  if valid_575129 != nil:
    section.add "resourceGroupName", valid_575129
  var valid_575130 = path.getOrDefault("subscriptionId")
  valid_575130 = validateParameter(valid_575130, JString, required = true,
                                 default = nil)
  if valid_575130 != nil:
    section.add "subscriptionId", valid_575130
  var valid_575131 = path.getOrDefault("applicationId")
  valid_575131 = validateParameter(valid_575131, JString, required = true,
                                 default = nil)
  if valid_575131 != nil:
    section.add "applicationId", valid_575131
  var valid_575132 = path.getOrDefault("accountName")
  valid_575132 = validateParameter(valid_575132, JString, required = true,
                                 default = nil)
  if valid_575132 != nil:
    section.add "accountName", valid_575132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575133 = query.getOrDefault("api-version")
  valid_575133 = validateParameter(valid_575133, JString, required = true,
                                 default = nil)
  if valid_575133 != nil:
    section.add "api-version", valid_575133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575135: Call_ApplicationUpdate_575126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates settings for the specified application.
  ## 
  let valid = call_575135.validator(path, query, header, formData, body)
  let scheme = call_575135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575135.url(scheme.get, call_575135.host, call_575135.base,
                         call_575135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575135, url, valid)

proc call*(call_575136: Call_ApplicationUpdate_575126; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; applicationId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## applicationUpdate
  ## Updates settings for the specified application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationId: string (required)
  ##                : The ID of the application.
  ##   parameters: JObject (required)
  ##             : The parameters for the request.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575137 = newJObject()
  var query_575138 = newJObject()
  var body_575139 = newJObject()
  add(path_575137, "resourceGroupName", newJString(resourceGroupName))
  add(query_575138, "api-version", newJString(apiVersion))
  add(path_575137, "subscriptionId", newJString(subscriptionId))
  add(path_575137, "applicationId", newJString(applicationId))
  if parameters != nil:
    body_575139 = parameters
  add(path_575137, "accountName", newJString(accountName))
  result = call_575136.call(path_575137, query_575138, nil, nil, body_575139)

var applicationUpdate* = Call_ApplicationUpdate_575126(name: "applicationUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}",
    validator: validate_ApplicationUpdate_575127, base: "",
    url: url_ApplicationUpdate_575128, schemes: {Scheme.Https})
type
  Call_ApplicationDelete_575114 = ref object of OpenApiRestCall_574457
proc url_ApplicationDelete_575116(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationDelete_575115(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationId: JString (required)
  ##                : The ID of the application.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575117 = path.getOrDefault("resourceGroupName")
  valid_575117 = validateParameter(valid_575117, JString, required = true,
                                 default = nil)
  if valid_575117 != nil:
    section.add "resourceGroupName", valid_575117
  var valid_575118 = path.getOrDefault("subscriptionId")
  valid_575118 = validateParameter(valid_575118, JString, required = true,
                                 default = nil)
  if valid_575118 != nil:
    section.add "subscriptionId", valid_575118
  var valid_575119 = path.getOrDefault("applicationId")
  valid_575119 = validateParameter(valid_575119, JString, required = true,
                                 default = nil)
  if valid_575119 != nil:
    section.add "applicationId", valid_575119
  var valid_575120 = path.getOrDefault("accountName")
  valid_575120 = validateParameter(valid_575120, JString, required = true,
                                 default = nil)
  if valid_575120 != nil:
    section.add "accountName", valid_575120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575121 = query.getOrDefault("api-version")
  valid_575121 = validateParameter(valid_575121, JString, required = true,
                                 default = nil)
  if valid_575121 != nil:
    section.add "api-version", valid_575121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575122: Call_ApplicationDelete_575114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application.
  ## 
  let valid = call_575122.validator(path, query, header, formData, body)
  let scheme = call_575122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575122.url(scheme.get, call_575122.host, call_575122.base,
                         call_575122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575122, url, valid)

proc call*(call_575123: Call_ApplicationDelete_575114; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; applicationId: string;
          accountName: string): Recallable =
  ## applicationDelete
  ## Deletes an application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationId: string (required)
  ##                : The ID of the application.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575124 = newJObject()
  var query_575125 = newJObject()
  add(path_575124, "resourceGroupName", newJString(resourceGroupName))
  add(query_575125, "api-version", newJString(apiVersion))
  add(path_575124, "subscriptionId", newJString(subscriptionId))
  add(path_575124, "applicationId", newJString(applicationId))
  add(path_575124, "accountName", newJString(accountName))
  result = call_575123.call(path_575124, query_575125, nil, nil, nil)

var applicationDelete* = Call_ApplicationDelete_575114(name: "applicationDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}",
    validator: validate_ApplicationDelete_575115, base: "",
    url: url_ApplicationDelete_575116, schemes: {Scheme.Https})
type
  Call_ApplicationPackageCreate_575153 = ref object of OpenApiRestCall_574457
proc url_ApplicationPackageCreate_575155(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationPackageCreate_575154(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an application package record.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   version: JString (required)
  ##          : The version of the application.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationId: JString (required)
  ##                : The ID of the application.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575156 = path.getOrDefault("resourceGroupName")
  valid_575156 = validateParameter(valid_575156, JString, required = true,
                                 default = nil)
  if valid_575156 != nil:
    section.add "resourceGroupName", valid_575156
  var valid_575157 = path.getOrDefault("version")
  valid_575157 = validateParameter(valid_575157, JString, required = true,
                                 default = nil)
  if valid_575157 != nil:
    section.add "version", valid_575157
  var valid_575158 = path.getOrDefault("subscriptionId")
  valid_575158 = validateParameter(valid_575158, JString, required = true,
                                 default = nil)
  if valid_575158 != nil:
    section.add "subscriptionId", valid_575158
  var valid_575159 = path.getOrDefault("applicationId")
  valid_575159 = validateParameter(valid_575159, JString, required = true,
                                 default = nil)
  if valid_575159 != nil:
    section.add "applicationId", valid_575159
  var valid_575160 = path.getOrDefault("accountName")
  valid_575160 = validateParameter(valid_575160, JString, required = true,
                                 default = nil)
  if valid_575160 != nil:
    section.add "accountName", valid_575160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575161 = query.getOrDefault("api-version")
  valid_575161 = validateParameter(valid_575161, JString, required = true,
                                 default = nil)
  if valid_575161 != nil:
    section.add "api-version", valid_575161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575162: Call_ApplicationPackageCreate_575153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an application package record.
  ## 
  let valid = call_575162.validator(path, query, header, formData, body)
  let scheme = call_575162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575162.url(scheme.get, call_575162.host, call_575162.base,
                         call_575162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575162, url, valid)

proc call*(call_575163: Call_ApplicationPackageCreate_575153;
          resourceGroupName: string; apiVersion: string; version: string;
          subscriptionId: string; applicationId: string; accountName: string): Recallable =
  ## applicationPackageCreate
  ## Creates an application package record.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   version: string (required)
  ##          : The version of the application.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationId: string (required)
  ##                : The ID of the application.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575164 = newJObject()
  var query_575165 = newJObject()
  add(path_575164, "resourceGroupName", newJString(resourceGroupName))
  add(query_575165, "api-version", newJString(apiVersion))
  add(path_575164, "version", newJString(version))
  add(path_575164, "subscriptionId", newJString(subscriptionId))
  add(path_575164, "applicationId", newJString(applicationId))
  add(path_575164, "accountName", newJString(accountName))
  result = call_575163.call(path_575164, query_575165, nil, nil, nil)

var applicationPackageCreate* = Call_ApplicationPackageCreate_575153(
    name: "applicationPackageCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}/versions/{version}",
    validator: validate_ApplicationPackageCreate_575154, base: "",
    url: url_ApplicationPackageCreate_575155, schemes: {Scheme.Https})
type
  Call_ApplicationPackageGet_575140 = ref object of OpenApiRestCall_574457
proc url_ApplicationPackageGet_575142(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationPackageGet_575141(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified application package.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   version: JString (required)
  ##          : The version of the application.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationId: JString (required)
  ##                : The ID of the application.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575143 = path.getOrDefault("resourceGroupName")
  valid_575143 = validateParameter(valid_575143, JString, required = true,
                                 default = nil)
  if valid_575143 != nil:
    section.add "resourceGroupName", valid_575143
  var valid_575144 = path.getOrDefault("version")
  valid_575144 = validateParameter(valid_575144, JString, required = true,
                                 default = nil)
  if valid_575144 != nil:
    section.add "version", valid_575144
  var valid_575145 = path.getOrDefault("subscriptionId")
  valid_575145 = validateParameter(valid_575145, JString, required = true,
                                 default = nil)
  if valid_575145 != nil:
    section.add "subscriptionId", valid_575145
  var valid_575146 = path.getOrDefault("applicationId")
  valid_575146 = validateParameter(valid_575146, JString, required = true,
                                 default = nil)
  if valid_575146 != nil:
    section.add "applicationId", valid_575146
  var valid_575147 = path.getOrDefault("accountName")
  valid_575147 = validateParameter(valid_575147, JString, required = true,
                                 default = nil)
  if valid_575147 != nil:
    section.add "accountName", valid_575147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575148 = query.getOrDefault("api-version")
  valid_575148 = validateParameter(valid_575148, JString, required = true,
                                 default = nil)
  if valid_575148 != nil:
    section.add "api-version", valid_575148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575149: Call_ApplicationPackageGet_575140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified application package.
  ## 
  let valid = call_575149.validator(path, query, header, formData, body)
  let scheme = call_575149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575149.url(scheme.get, call_575149.host, call_575149.base,
                         call_575149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575149, url, valid)

proc call*(call_575150: Call_ApplicationPackageGet_575140;
          resourceGroupName: string; apiVersion: string; version: string;
          subscriptionId: string; applicationId: string; accountName: string): Recallable =
  ## applicationPackageGet
  ## Gets information about the specified application package.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   version: string (required)
  ##          : The version of the application.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationId: string (required)
  ##                : The ID of the application.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575151 = newJObject()
  var query_575152 = newJObject()
  add(path_575151, "resourceGroupName", newJString(resourceGroupName))
  add(query_575152, "api-version", newJString(apiVersion))
  add(path_575151, "version", newJString(version))
  add(path_575151, "subscriptionId", newJString(subscriptionId))
  add(path_575151, "applicationId", newJString(applicationId))
  add(path_575151, "accountName", newJString(accountName))
  result = call_575150.call(path_575151, query_575152, nil, nil, nil)

var applicationPackageGet* = Call_ApplicationPackageGet_575140(
    name: "applicationPackageGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}/versions/{version}",
    validator: validate_ApplicationPackageGet_575141, base: "",
    url: url_ApplicationPackageGet_575142, schemes: {Scheme.Https})
type
  Call_ApplicationPackageDelete_575166 = ref object of OpenApiRestCall_574457
proc url_ApplicationPackageDelete_575168(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationPackageDelete_575167(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an application package record and its associated binary file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   version: JString (required)
  ##          : The version of the application to delete.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationId: JString (required)
  ##                : The ID of the application.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575169 = path.getOrDefault("resourceGroupName")
  valid_575169 = validateParameter(valid_575169, JString, required = true,
                                 default = nil)
  if valid_575169 != nil:
    section.add "resourceGroupName", valid_575169
  var valid_575170 = path.getOrDefault("version")
  valid_575170 = validateParameter(valid_575170, JString, required = true,
                                 default = nil)
  if valid_575170 != nil:
    section.add "version", valid_575170
  var valid_575171 = path.getOrDefault("subscriptionId")
  valid_575171 = validateParameter(valid_575171, JString, required = true,
                                 default = nil)
  if valid_575171 != nil:
    section.add "subscriptionId", valid_575171
  var valid_575172 = path.getOrDefault("applicationId")
  valid_575172 = validateParameter(valid_575172, JString, required = true,
                                 default = nil)
  if valid_575172 != nil:
    section.add "applicationId", valid_575172
  var valid_575173 = path.getOrDefault("accountName")
  valid_575173 = validateParameter(valid_575173, JString, required = true,
                                 default = nil)
  if valid_575173 != nil:
    section.add "accountName", valid_575173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575174 = query.getOrDefault("api-version")
  valid_575174 = validateParameter(valid_575174, JString, required = true,
                                 default = nil)
  if valid_575174 != nil:
    section.add "api-version", valid_575174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575175: Call_ApplicationPackageDelete_575166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application package record and its associated binary file.
  ## 
  let valid = call_575175.validator(path, query, header, formData, body)
  let scheme = call_575175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575175.url(scheme.get, call_575175.host, call_575175.base,
                         call_575175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575175, url, valid)

proc call*(call_575176: Call_ApplicationPackageDelete_575166;
          resourceGroupName: string; apiVersion: string; version: string;
          subscriptionId: string; applicationId: string; accountName: string): Recallable =
  ## applicationPackageDelete
  ## Deletes an application package record and its associated binary file.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   version: string (required)
  ##          : The version of the application to delete.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationId: string (required)
  ##                : The ID of the application.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575177 = newJObject()
  var query_575178 = newJObject()
  add(path_575177, "resourceGroupName", newJString(resourceGroupName))
  add(query_575178, "api-version", newJString(apiVersion))
  add(path_575177, "version", newJString(version))
  add(path_575177, "subscriptionId", newJString(subscriptionId))
  add(path_575177, "applicationId", newJString(applicationId))
  add(path_575177, "accountName", newJString(accountName))
  result = call_575176.call(path_575177, query_575178, nil, nil, nil)

var applicationPackageDelete* = Call_ApplicationPackageDelete_575166(
    name: "applicationPackageDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}/versions/{version}",
    validator: validate_ApplicationPackageDelete_575167, base: "",
    url: url_ApplicationPackageDelete_575168, schemes: {Scheme.Https})
type
  Call_ApplicationPackageActivate_575179 = ref object of OpenApiRestCall_574457
proc url_ApplicationPackageActivate_575181(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version"),
               (kind: ConstantSegment, value: "/activate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationPackageActivate_575180(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Activates the specified application package.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   version: JString (required)
  ##          : The version of the application to activate.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationId: JString (required)
  ##                : The ID of the application.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575182 = path.getOrDefault("resourceGroupName")
  valid_575182 = validateParameter(valid_575182, JString, required = true,
                                 default = nil)
  if valid_575182 != nil:
    section.add "resourceGroupName", valid_575182
  var valid_575183 = path.getOrDefault("version")
  valid_575183 = validateParameter(valid_575183, JString, required = true,
                                 default = nil)
  if valid_575183 != nil:
    section.add "version", valid_575183
  var valid_575184 = path.getOrDefault("subscriptionId")
  valid_575184 = validateParameter(valid_575184, JString, required = true,
                                 default = nil)
  if valid_575184 != nil:
    section.add "subscriptionId", valid_575184
  var valid_575185 = path.getOrDefault("applicationId")
  valid_575185 = validateParameter(valid_575185, JString, required = true,
                                 default = nil)
  if valid_575185 != nil:
    section.add "applicationId", valid_575185
  var valid_575186 = path.getOrDefault("accountName")
  valid_575186 = validateParameter(valid_575186, JString, required = true,
                                 default = nil)
  if valid_575186 != nil:
    section.add "accountName", valid_575186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575187 = query.getOrDefault("api-version")
  valid_575187 = validateParameter(valid_575187, JString, required = true,
                                 default = nil)
  if valid_575187 != nil:
    section.add "api-version", valid_575187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575189: Call_ApplicationPackageActivate_575179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activates the specified application package.
  ## 
  let valid = call_575189.validator(path, query, header, formData, body)
  let scheme = call_575189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575189.url(scheme.get, call_575189.host, call_575189.base,
                         call_575189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575189, url, valid)

proc call*(call_575190: Call_ApplicationPackageActivate_575179;
          resourceGroupName: string; apiVersion: string; version: string;
          subscriptionId: string; applicationId: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## applicationPackageActivate
  ## Activates the specified application package.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   version: string (required)
  ##          : The version of the application to activate.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationId: string (required)
  ##                : The ID of the application.
  ##   parameters: JObject (required)
  ##             : The parameters for the request.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575191 = newJObject()
  var query_575192 = newJObject()
  var body_575193 = newJObject()
  add(path_575191, "resourceGroupName", newJString(resourceGroupName))
  add(query_575192, "api-version", newJString(apiVersion))
  add(path_575191, "version", newJString(version))
  add(path_575191, "subscriptionId", newJString(subscriptionId))
  add(path_575191, "applicationId", newJString(applicationId))
  if parameters != nil:
    body_575193 = parameters
  add(path_575191, "accountName", newJString(accountName))
  result = call_575190.call(path_575191, query_575192, nil, nil, body_575193)

var applicationPackageActivate* = Call_ApplicationPackageActivate_575179(
    name: "applicationPackageActivate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}/versions/{version}/activate",
    validator: validate_ApplicationPackageActivate_575180, base: "",
    url: url_ApplicationPackageActivate_575181, schemes: {Scheme.Https})
type
  Call_BatchAccountGetKeys_575194 = ref object of OpenApiRestCall_574457
proc url_BatchAccountGetKeys_575196(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountGetKeys_575195(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## This operation applies only to Batch accounts created with a poolAllocationMode of 'BatchService'. If the Batch account was created with a poolAllocationMode of 'UserSubscription', clients cannot use access to keys to authenticate, and must use Azure Active Directory instead. In this case, getting the keys will fail.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575197 = path.getOrDefault("resourceGroupName")
  valid_575197 = validateParameter(valid_575197, JString, required = true,
                                 default = nil)
  if valid_575197 != nil:
    section.add "resourceGroupName", valid_575197
  var valid_575198 = path.getOrDefault("subscriptionId")
  valid_575198 = validateParameter(valid_575198, JString, required = true,
                                 default = nil)
  if valid_575198 != nil:
    section.add "subscriptionId", valid_575198
  var valid_575199 = path.getOrDefault("accountName")
  valid_575199 = validateParameter(valid_575199, JString, required = true,
                                 default = nil)
  if valid_575199 != nil:
    section.add "accountName", valid_575199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575200 = query.getOrDefault("api-version")
  valid_575200 = validateParameter(valid_575200, JString, required = true,
                                 default = nil)
  if valid_575200 != nil:
    section.add "api-version", valid_575200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575201: Call_BatchAccountGetKeys_575194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation applies only to Batch accounts created with a poolAllocationMode of 'BatchService'. If the Batch account was created with a poolAllocationMode of 'UserSubscription', clients cannot use access to keys to authenticate, and must use Azure Active Directory instead. In this case, getting the keys will fail.
  ## 
  let valid = call_575201.validator(path, query, header, formData, body)
  let scheme = call_575201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575201.url(scheme.get, call_575201.host, call_575201.base,
                         call_575201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575201, url, valid)

proc call*(call_575202: Call_BatchAccountGetKeys_575194; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## batchAccountGetKeys
  ## This operation applies only to Batch accounts created with a poolAllocationMode of 'BatchService'. If the Batch account was created with a poolAllocationMode of 'UserSubscription', clients cannot use access to keys to authenticate, and must use Azure Active Directory instead. In this case, getting the keys will fail.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the account.
  var path_575203 = newJObject()
  var query_575204 = newJObject()
  add(path_575203, "resourceGroupName", newJString(resourceGroupName))
  add(query_575204, "api-version", newJString(apiVersion))
  add(path_575203, "subscriptionId", newJString(subscriptionId))
  add(path_575203, "accountName", newJString(accountName))
  result = call_575202.call(path_575203, query_575204, nil, nil, nil)

var batchAccountGetKeys* = Call_BatchAccountGetKeys_575194(
    name: "batchAccountGetKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/listKeys",
    validator: validate_BatchAccountGetKeys_575195, base: "",
    url: url_BatchAccountGetKeys_575196, schemes: {Scheme.Https})
type
  Call_BatchAccountRegenerateKey_575205 = ref object of OpenApiRestCall_574457
proc url_BatchAccountRegenerateKey_575207(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountRegenerateKey_575206(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the specified account key for the Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575208 = path.getOrDefault("resourceGroupName")
  valid_575208 = validateParameter(valid_575208, JString, required = true,
                                 default = nil)
  if valid_575208 != nil:
    section.add "resourceGroupName", valid_575208
  var valid_575209 = path.getOrDefault("subscriptionId")
  valid_575209 = validateParameter(valid_575209, JString, required = true,
                                 default = nil)
  if valid_575209 != nil:
    section.add "subscriptionId", valid_575209
  var valid_575210 = path.getOrDefault("accountName")
  valid_575210 = validateParameter(valid_575210, JString, required = true,
                                 default = nil)
  if valid_575210 != nil:
    section.add "accountName", valid_575210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575211 = query.getOrDefault("api-version")
  valid_575211 = validateParameter(valid_575211, JString, required = true,
                                 default = nil)
  if valid_575211 != nil:
    section.add "api-version", valid_575211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The type of key to regenerate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575213: Call_BatchAccountRegenerateKey_575205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the specified account key for the Batch account.
  ## 
  let valid = call_575213.validator(path, query, header, formData, body)
  let scheme = call_575213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575213.url(scheme.get, call_575213.host, call_575213.base,
                         call_575213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575213, url, valid)

proc call*(call_575214: Call_BatchAccountRegenerateKey_575205;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## batchAccountRegenerateKey
  ## Regenerates the specified account key for the Batch account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The type of key to regenerate.
  ##   accountName: string (required)
  ##              : The name of the account.
  var path_575215 = newJObject()
  var query_575216 = newJObject()
  var body_575217 = newJObject()
  add(path_575215, "resourceGroupName", newJString(resourceGroupName))
  add(query_575216, "api-version", newJString(apiVersion))
  add(path_575215, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575217 = parameters
  add(path_575215, "accountName", newJString(accountName))
  result = call_575214.call(path_575215, query_575216, nil, nil, body_575217)

var batchAccountRegenerateKey* = Call_BatchAccountRegenerateKey_575205(
    name: "batchAccountRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/regenerateKeys",
    validator: validate_BatchAccountRegenerateKey_575206, base: "",
    url: url_BatchAccountRegenerateKey_575207, schemes: {Scheme.Https})
type
  Call_BatchAccountSynchronizeAutoStorageKeys_575218 = ref object of OpenApiRestCall_574457
proc url_BatchAccountSynchronizeAutoStorageKeys_575220(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/syncAutoStorageKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountSynchronizeAutoStorageKeys_575219(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Synchronizes access keys for the auto storage account configured for the specified Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575221 = path.getOrDefault("resourceGroupName")
  valid_575221 = validateParameter(valid_575221, JString, required = true,
                                 default = nil)
  if valid_575221 != nil:
    section.add "resourceGroupName", valid_575221
  var valid_575222 = path.getOrDefault("subscriptionId")
  valid_575222 = validateParameter(valid_575222, JString, required = true,
                                 default = nil)
  if valid_575222 != nil:
    section.add "subscriptionId", valid_575222
  var valid_575223 = path.getOrDefault("accountName")
  valid_575223 = validateParameter(valid_575223, JString, required = true,
                                 default = nil)
  if valid_575223 != nil:
    section.add "accountName", valid_575223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575224 = query.getOrDefault("api-version")
  valid_575224 = validateParameter(valid_575224, JString, required = true,
                                 default = nil)
  if valid_575224 != nil:
    section.add "api-version", valid_575224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575225: Call_BatchAccountSynchronizeAutoStorageKeys_575218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Synchronizes access keys for the auto storage account configured for the specified Batch account.
  ## 
  let valid = call_575225.validator(path, query, header, formData, body)
  let scheme = call_575225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575225.url(scheme.get, call_575225.host, call_575225.base,
                         call_575225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575225, url, valid)

proc call*(call_575226: Call_BatchAccountSynchronizeAutoStorageKeys_575218;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## batchAccountSynchronizeAutoStorageKeys
  ## Synchronizes access keys for the auto storage account configured for the specified Batch account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier of a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575227 = newJObject()
  var query_575228 = newJObject()
  add(path_575227, "resourceGroupName", newJString(resourceGroupName))
  add(query_575228, "api-version", newJString(apiVersion))
  add(path_575227, "subscriptionId", newJString(subscriptionId))
  add(path_575227, "accountName", newJString(accountName))
  result = call_575226.call(path_575227, query_575228, nil, nil, nil)

var batchAccountSynchronizeAutoStorageKeys* = Call_BatchAccountSynchronizeAutoStorageKeys_575218(
    name: "batchAccountSynchronizeAutoStorageKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/syncAutoStorageKeys",
    validator: validate_BatchAccountSynchronizeAutoStorageKeys_575219, base: "",
    url: url_BatchAccountSynchronizeAutoStorageKeys_575220,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
