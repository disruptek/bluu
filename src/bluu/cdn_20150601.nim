
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: CdnManagementClient
## version: 2015-06-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these APIs to manage Azure CDN resources through the Azure Resource Manager. You must make sure that requests made to these resources are secure. For more information, see https://msdn.microsoft.com/en-us/library/azure/dn790557.aspx.
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

  OpenApiRestCall_563540 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563540](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563540): Option[Scheme] {.used.} =
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
  macServiceName = "cdn"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_NameAvailabilityCheckNameAvailability_563762 = ref object of OpenApiRestCall_563540
proc url_NameAvailabilityCheckNameAvailability_563764(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_NameAvailabilityCheckNameAvailability_563763(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563925 = query.getOrDefault("api-version")
  valid_563925 = validateParameter(valid_563925, JString, required = true,
                                 default = nil)
  if valid_563925 != nil:
    section.add "api-version", valid_563925
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   checkNameAvailabilityInput: JObject (required)
  ##                             : Input to check.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_563949: Call_NameAvailabilityCheckNameAvailability_563762;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_563949.validator(path, query, header, formData, body)
  let scheme = call_563949.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563949.url(scheme.get, call_563949.host, call_563949.base,
                         call_563949.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563949, url, valid)

proc call*(call_564020: Call_NameAvailabilityCheckNameAvailability_563762;
          apiVersion: string; checkNameAvailabilityInput: JsonNode): Recallable =
  ## nameAvailabilityCheckNameAvailability
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   checkNameAvailabilityInput: JObject (required)
  ##                             : Input to check.
  var query_564021 = newJObject()
  var body_564023 = newJObject()
  add(query_564021, "api-version", newJString(apiVersion))
  if checkNameAvailabilityInput != nil:
    body_564023 = checkNameAvailabilityInput
  result = call_564020.call(nil, query_564021, nil, nil, body_564023)

var nameAvailabilityCheckNameAvailability* = Call_NameAvailabilityCheckNameAvailability_563762(
    name: "nameAvailabilityCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Cdn/checkNameAvailability",
    validator: validate_NameAvailabilityCheckNameAvailability_563763, base: "",
    url: url_NameAvailabilityCheckNameAvailability_563764, schemes: {Scheme.Https})
type
  Call_OperationsList_564062 = ref object of OpenApiRestCall_563540
proc url_OperationsList_564064(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_564063(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564065 = query.getOrDefault("api-version")
  valid_564065 = validateParameter(valid_564065, JString, required = true,
                                 default = nil)
  if valid_564065 != nil:
    section.add "api-version", valid_564065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564066: Call_OperationsList_564062; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564066.validator(path, query, header, formData, body)
  let scheme = call_564066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564066.url(scheme.get, call_564066.host, call_564066.base,
                         call_564066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564066, url, valid)

proc call*(call_564067: Call_OperationsList_564062; apiVersion: string): Recallable =
  ## operationsList
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  var query_564068 = newJObject()
  add(query_564068, "api-version", newJString(apiVersion))
  result = call_564067.call(nil, query_564068, nil, nil, nil)

var operationsList* = Call_OperationsList_564062(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Cdn/operations",
    validator: validate_OperationsList_564063, base: "", url: url_OperationsList_564064,
    schemes: {Scheme.Https})
type
  Call_ProfilesListBySubscriptionId_564069 = ref object of OpenApiRestCall_563540
proc url_ProfilesListBySubscriptionId_564071(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesListBySubscriptionId_564070(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564086 = path.getOrDefault("subscriptionId")
  valid_564086 = validateParameter(valid_564086, JString, required = true,
                                 default = nil)
  if valid_564086 != nil:
    section.add "subscriptionId", valid_564086
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564087 = query.getOrDefault("api-version")
  valid_564087 = validateParameter(valid_564087, JString, required = true,
                                 default = nil)
  if valid_564087 != nil:
    section.add "api-version", valid_564087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564088: Call_ProfilesListBySubscriptionId_564069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564088.validator(path, query, header, formData, body)
  let scheme = call_564088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564088.url(scheme.get, call_564088.host, call_564088.base,
                         call_564088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564088, url, valid)

proc call*(call_564089: Call_ProfilesListBySubscriptionId_564069;
          apiVersion: string; subscriptionId: string): Recallable =
  ## profilesListBySubscriptionId
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_564090 = newJObject()
  var query_564091 = newJObject()
  add(query_564091, "api-version", newJString(apiVersion))
  add(path_564090, "subscriptionId", newJString(subscriptionId))
  result = call_564089.call(path_564090, query_564091, nil, nil, nil)

var profilesListBySubscriptionId* = Call_ProfilesListBySubscriptionId_564069(
    name: "profilesListBySubscriptionId", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/profiles",
    validator: validate_ProfilesListBySubscriptionId_564070, base: "",
    url: url_ProfilesListBySubscriptionId_564071, schemes: {Scheme.Https})
type
  Call_ProfilesListByResourceGroup_564092 = ref object of OpenApiRestCall_563540
proc url_ProfilesListByResourceGroup_564094(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesListByResourceGroup_564093(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564095 = path.getOrDefault("subscriptionId")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "subscriptionId", valid_564095
  var valid_564096 = path.getOrDefault("resourceGroupName")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "resourceGroupName", valid_564096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564097 = query.getOrDefault("api-version")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "api-version", valid_564097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564098: Call_ProfilesListByResourceGroup_564092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564098.validator(path, query, header, formData, body)
  let scheme = call_564098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564098.url(scheme.get, call_564098.host, call_564098.base,
                         call_564098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564098, url, valid)

proc call*(call_564099: Call_ProfilesListByResourceGroup_564092;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## profilesListByResourceGroup
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564100 = newJObject()
  var query_564101 = newJObject()
  add(query_564101, "api-version", newJString(apiVersion))
  add(path_564100, "subscriptionId", newJString(subscriptionId))
  add(path_564100, "resourceGroupName", newJString(resourceGroupName))
  result = call_564099.call(path_564100, query_564101, nil, nil, nil)

var profilesListByResourceGroup* = Call_ProfilesListByResourceGroup_564092(
    name: "profilesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles",
    validator: validate_ProfilesListByResourceGroup_564093, base: "",
    url: url_ProfilesListByResourceGroup_564094, schemes: {Scheme.Https})
type
  Call_ProfilesCreate_564113 = ref object of OpenApiRestCall_563540
proc url_ProfilesCreate_564115(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesCreate_564114(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564116 = path.getOrDefault("profileName")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "profileName", valid_564116
  var valid_564117 = path.getOrDefault("subscriptionId")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "subscriptionId", valid_564117
  var valid_564118 = path.getOrDefault("resourceGroupName")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "resourceGroupName", valid_564118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   profileProperties: JObject (required)
  ##                    : Profile properties needed for creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564121: Call_ProfilesCreate_564113; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564121.validator(path, query, header, formData, body)
  let scheme = call_564121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564121.url(scheme.get, call_564121.host, call_564121.base,
                         call_564121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564121, url, valid)

proc call*(call_564122: Call_ProfilesCreate_564113; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          profileProperties: JsonNode): Recallable =
  ## profilesCreate
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   profileProperties: JObject (required)
  ##                    : Profile properties needed for creation.
  var path_564123 = newJObject()
  var query_564124 = newJObject()
  var body_564125 = newJObject()
  add(path_564123, "profileName", newJString(profileName))
  add(query_564124, "api-version", newJString(apiVersion))
  add(path_564123, "subscriptionId", newJString(subscriptionId))
  add(path_564123, "resourceGroupName", newJString(resourceGroupName))
  if profileProperties != nil:
    body_564125 = profileProperties
  result = call_564122.call(path_564123, query_564124, nil, nil, body_564125)

var profilesCreate* = Call_ProfilesCreate_564113(name: "profilesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesCreate_564114, base: "", url: url_ProfilesCreate_564115,
    schemes: {Scheme.Https})
type
  Call_ProfilesGet_564102 = ref object of OpenApiRestCall_563540
proc url_ProfilesGet_564104(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesGet_564103(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564105 = path.getOrDefault("profileName")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "profileName", valid_564105
  var valid_564106 = path.getOrDefault("subscriptionId")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "subscriptionId", valid_564106
  var valid_564107 = path.getOrDefault("resourceGroupName")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "resourceGroupName", valid_564107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564108 = query.getOrDefault("api-version")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "api-version", valid_564108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564109: Call_ProfilesGet_564102; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564109.validator(path, query, header, formData, body)
  let scheme = call_564109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564109.url(scheme.get, call_564109.host, call_564109.base,
                         call_564109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564109, url, valid)

proc call*(call_564110: Call_ProfilesGet_564102; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## profilesGet
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564111 = newJObject()
  var query_564112 = newJObject()
  add(path_564111, "profileName", newJString(profileName))
  add(query_564112, "api-version", newJString(apiVersion))
  add(path_564111, "subscriptionId", newJString(subscriptionId))
  add(path_564111, "resourceGroupName", newJString(resourceGroupName))
  result = call_564110.call(path_564111, query_564112, nil, nil, nil)

var profilesGet* = Call_ProfilesGet_564102(name: "profilesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
                                        validator: validate_ProfilesGet_564103,
                                        base: "", url: url_ProfilesGet_564104,
                                        schemes: {Scheme.Https})
type
  Call_ProfilesUpdate_564137 = ref object of OpenApiRestCall_563540
proc url_ProfilesUpdate_564139(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesUpdate_564138(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564140 = path.getOrDefault("profileName")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "profileName", valid_564140
  var valid_564141 = path.getOrDefault("subscriptionId")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "subscriptionId", valid_564141
  var valid_564142 = path.getOrDefault("resourceGroupName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "resourceGroupName", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   profileProperties: JObject (required)
  ##                    : Profile properties needed for update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564145: Call_ProfilesUpdate_564137; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564145.validator(path, query, header, formData, body)
  let scheme = call_564145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564145.url(scheme.get, call_564145.host, call_564145.base,
                         call_564145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564145, url, valid)

proc call*(call_564146: Call_ProfilesUpdate_564137; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          profileProperties: JsonNode): Recallable =
  ## profilesUpdate
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   profileProperties: JObject (required)
  ##                    : Profile properties needed for update.
  var path_564147 = newJObject()
  var query_564148 = newJObject()
  var body_564149 = newJObject()
  add(path_564147, "profileName", newJString(profileName))
  add(query_564148, "api-version", newJString(apiVersion))
  add(path_564147, "subscriptionId", newJString(subscriptionId))
  add(path_564147, "resourceGroupName", newJString(resourceGroupName))
  if profileProperties != nil:
    body_564149 = profileProperties
  result = call_564146.call(path_564147, query_564148, nil, nil, body_564149)

var profilesUpdate* = Call_ProfilesUpdate_564137(name: "profilesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesUpdate_564138, base: "", url: url_ProfilesUpdate_564139,
    schemes: {Scheme.Https})
type
  Call_ProfilesDeleteIfExists_564126 = ref object of OpenApiRestCall_563540
proc url_ProfilesDeleteIfExists_564128(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesDeleteIfExists_564127(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564129 = path.getOrDefault("profileName")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "profileName", valid_564129
  var valid_564130 = path.getOrDefault("subscriptionId")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "subscriptionId", valid_564130
  var valid_564131 = path.getOrDefault("resourceGroupName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "resourceGroupName", valid_564131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564132 = query.getOrDefault("api-version")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "api-version", valid_564132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_ProfilesDeleteIfExists_564126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_ProfilesDeleteIfExists_564126; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## profilesDeleteIfExists
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  add(path_564135, "profileName", newJString(profileName))
  add(query_564136, "api-version", newJString(apiVersion))
  add(path_564135, "subscriptionId", newJString(subscriptionId))
  add(path_564135, "resourceGroupName", newJString(resourceGroupName))
  result = call_564134.call(path_564135, query_564136, nil, nil, nil)

var profilesDeleteIfExists* = Call_ProfilesDeleteIfExists_564126(
    name: "profilesDeleteIfExists", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesDeleteIfExists_564127, base: "",
    url: url_ProfilesDeleteIfExists_564128, schemes: {Scheme.Https})
type
  Call_EndpointsListByProfile_564150 = ref object of OpenApiRestCall_563540
proc url_EndpointsListByProfile_564152(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsListByProfile_564151(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564153 = path.getOrDefault("profileName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "profileName", valid_564153
  var valid_564154 = path.getOrDefault("subscriptionId")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "subscriptionId", valid_564154
  var valid_564155 = path.getOrDefault("resourceGroupName")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "resourceGroupName", valid_564155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564156 = query.getOrDefault("api-version")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "api-version", valid_564156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564157: Call_EndpointsListByProfile_564150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564157.validator(path, query, header, formData, body)
  let scheme = call_564157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564157.url(scheme.get, call_564157.host, call_564157.base,
                         call_564157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564157, url, valid)

proc call*(call_564158: Call_EndpointsListByProfile_564150; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## endpointsListByProfile
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564159 = newJObject()
  var query_564160 = newJObject()
  add(path_564159, "profileName", newJString(profileName))
  add(query_564160, "api-version", newJString(apiVersion))
  add(path_564159, "subscriptionId", newJString(subscriptionId))
  add(path_564159, "resourceGroupName", newJString(resourceGroupName))
  result = call_564158.call(path_564159, query_564160, nil, nil, nil)

var endpointsListByProfile* = Call_EndpointsListByProfile_564150(
    name: "endpointsListByProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints",
    validator: validate_EndpointsListByProfile_564151, base: "",
    url: url_EndpointsListByProfile_564152, schemes: {Scheme.Https})
type
  Call_EndpointsCreate_564173 = ref object of OpenApiRestCall_563540
proc url_EndpointsCreate_564175(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsCreate_564174(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564176 = path.getOrDefault("profileName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "profileName", valid_564176
  var valid_564177 = path.getOrDefault("subscriptionId")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "subscriptionId", valid_564177
  var valid_564178 = path.getOrDefault("resourceGroupName")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "resourceGroupName", valid_564178
  var valid_564179 = path.getOrDefault("endpointName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "endpointName", valid_564179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564180 = query.getOrDefault("api-version")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "api-version", valid_564180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   endpointProperties: JObject (required)
  ##                     : Endpoint properties
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564182: Call_EndpointsCreate_564173; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564182.validator(path, query, header, formData, body)
  let scheme = call_564182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564182.url(scheme.get, call_564182.host, call_564182.base,
                         call_564182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564182, url, valid)

proc call*(call_564183: Call_EndpointsCreate_564173; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          endpointName: string; endpointProperties: JsonNode): Recallable =
  ## endpointsCreate
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  ##   endpointProperties: JObject (required)
  ##                     : Endpoint properties
  var path_564184 = newJObject()
  var query_564185 = newJObject()
  var body_564186 = newJObject()
  add(path_564184, "profileName", newJString(profileName))
  add(query_564185, "api-version", newJString(apiVersion))
  add(path_564184, "subscriptionId", newJString(subscriptionId))
  add(path_564184, "resourceGroupName", newJString(resourceGroupName))
  add(path_564184, "endpointName", newJString(endpointName))
  if endpointProperties != nil:
    body_564186 = endpointProperties
  result = call_564183.call(path_564184, query_564185, nil, nil, body_564186)

var endpointsCreate* = Call_EndpointsCreate_564173(name: "endpointsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsCreate_564174, base: "", url: url_EndpointsCreate_564175,
    schemes: {Scheme.Https})
type
  Call_EndpointsGet_564161 = ref object of OpenApiRestCall_563540
proc url_EndpointsGet_564163(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsGet_564162(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564164 = path.getOrDefault("profileName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "profileName", valid_564164
  var valid_564165 = path.getOrDefault("subscriptionId")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "subscriptionId", valid_564165
  var valid_564166 = path.getOrDefault("resourceGroupName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "resourceGroupName", valid_564166
  var valid_564167 = path.getOrDefault("endpointName")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "endpointName", valid_564167
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564168 = query.getOrDefault("api-version")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "api-version", valid_564168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564169: Call_EndpointsGet_564161; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564169.validator(path, query, header, formData, body)
  let scheme = call_564169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564169.url(scheme.get, call_564169.host, call_564169.base,
                         call_564169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564169, url, valid)

proc call*(call_564170: Call_EndpointsGet_564161; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          endpointName: string): Recallable =
  ## endpointsGet
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564171 = newJObject()
  var query_564172 = newJObject()
  add(path_564171, "profileName", newJString(profileName))
  add(query_564172, "api-version", newJString(apiVersion))
  add(path_564171, "subscriptionId", newJString(subscriptionId))
  add(path_564171, "resourceGroupName", newJString(resourceGroupName))
  add(path_564171, "endpointName", newJString(endpointName))
  result = call_564170.call(path_564171, query_564172, nil, nil, nil)

var endpointsGet* = Call_EndpointsGet_564161(name: "endpointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsGet_564162, base: "", url: url_EndpointsGet_564163,
    schemes: {Scheme.Https})
type
  Call_EndpointsUpdate_564199 = ref object of OpenApiRestCall_563540
proc url_EndpointsUpdate_564201(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsUpdate_564200(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564202 = path.getOrDefault("profileName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "profileName", valid_564202
  var valid_564203 = path.getOrDefault("subscriptionId")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "subscriptionId", valid_564203
  var valid_564204 = path.getOrDefault("resourceGroupName")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "resourceGroupName", valid_564204
  var valid_564205 = path.getOrDefault("endpointName")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "endpointName", valid_564205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564206 = query.getOrDefault("api-version")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "api-version", valid_564206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   endpointProperties: JObject (required)
  ##                     : Endpoint properties
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564208: Call_EndpointsUpdate_564199; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564208.validator(path, query, header, formData, body)
  let scheme = call_564208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564208.url(scheme.get, call_564208.host, call_564208.base,
                         call_564208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564208, url, valid)

proc call*(call_564209: Call_EndpointsUpdate_564199; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          endpointName: string; endpointProperties: JsonNode): Recallable =
  ## endpointsUpdate
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  ##   endpointProperties: JObject (required)
  ##                     : Endpoint properties
  var path_564210 = newJObject()
  var query_564211 = newJObject()
  var body_564212 = newJObject()
  add(path_564210, "profileName", newJString(profileName))
  add(query_564211, "api-version", newJString(apiVersion))
  add(path_564210, "subscriptionId", newJString(subscriptionId))
  add(path_564210, "resourceGroupName", newJString(resourceGroupName))
  add(path_564210, "endpointName", newJString(endpointName))
  if endpointProperties != nil:
    body_564212 = endpointProperties
  result = call_564209.call(path_564210, query_564211, nil, nil, body_564212)

var endpointsUpdate* = Call_EndpointsUpdate_564199(name: "endpointsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsUpdate_564200, base: "", url: url_EndpointsUpdate_564201,
    schemes: {Scheme.Https})
type
  Call_EndpointsDeleteIfExists_564187 = ref object of OpenApiRestCall_563540
proc url_EndpointsDeleteIfExists_564189(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsDeleteIfExists_564188(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564190 = path.getOrDefault("profileName")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "profileName", valid_564190
  var valid_564191 = path.getOrDefault("subscriptionId")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "subscriptionId", valid_564191
  var valid_564192 = path.getOrDefault("resourceGroupName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "resourceGroupName", valid_564192
  var valid_564193 = path.getOrDefault("endpointName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "endpointName", valid_564193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564194 = query.getOrDefault("api-version")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "api-version", valid_564194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564195: Call_EndpointsDeleteIfExists_564187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564195.validator(path, query, header, formData, body)
  let scheme = call_564195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564195.url(scheme.get, call_564195.host, call_564195.base,
                         call_564195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564195, url, valid)

proc call*(call_564196: Call_EndpointsDeleteIfExists_564187; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          endpointName: string): Recallable =
  ## endpointsDeleteIfExists
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564197 = newJObject()
  var query_564198 = newJObject()
  add(path_564197, "profileName", newJString(profileName))
  add(query_564198, "api-version", newJString(apiVersion))
  add(path_564197, "subscriptionId", newJString(subscriptionId))
  add(path_564197, "resourceGroupName", newJString(resourceGroupName))
  add(path_564197, "endpointName", newJString(endpointName))
  result = call_564196.call(path_564197, query_564198, nil, nil, nil)

var endpointsDeleteIfExists* = Call_EndpointsDeleteIfExists_564187(
    name: "endpointsDeleteIfExists", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsDeleteIfExists_564188, base: "",
    url: url_EndpointsDeleteIfExists_564189, schemes: {Scheme.Https})
type
  Call_CustomDomainsListByEndpoint_564213 = ref object of OpenApiRestCall_563540
proc url_CustomDomainsListByEndpoint_564215(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsListByEndpoint_564214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564216 = path.getOrDefault("profileName")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "profileName", valid_564216
  var valid_564217 = path.getOrDefault("subscriptionId")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "subscriptionId", valid_564217
  var valid_564218 = path.getOrDefault("resourceGroupName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "resourceGroupName", valid_564218
  var valid_564219 = path.getOrDefault("endpointName")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "endpointName", valid_564219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564220 = query.getOrDefault("api-version")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "api-version", valid_564220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564221: Call_CustomDomainsListByEndpoint_564213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564221.validator(path, query, header, formData, body)
  let scheme = call_564221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564221.url(scheme.get, call_564221.host, call_564221.base,
                         call_564221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564221, url, valid)

proc call*(call_564222: Call_CustomDomainsListByEndpoint_564213;
          profileName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; endpointName: string): Recallable =
  ## customDomainsListByEndpoint
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564223 = newJObject()
  var query_564224 = newJObject()
  add(path_564223, "profileName", newJString(profileName))
  add(query_564224, "api-version", newJString(apiVersion))
  add(path_564223, "subscriptionId", newJString(subscriptionId))
  add(path_564223, "resourceGroupName", newJString(resourceGroupName))
  add(path_564223, "endpointName", newJString(endpointName))
  result = call_564222.call(path_564223, query_564224, nil, nil, nil)

var customDomainsListByEndpoint* = Call_CustomDomainsListByEndpoint_564213(
    name: "customDomainsListByEndpoint", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains",
    validator: validate_CustomDomainsListByEndpoint_564214, base: "",
    url: url_CustomDomainsListByEndpoint_564215, schemes: {Scheme.Https})
type
  Call_CustomDomainsCreate_564238 = ref object of OpenApiRestCall_563540
proc url_CustomDomainsCreate_564240(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "customDomainName" in path,
        "`customDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains/"),
               (kind: VariableSegment, value: "customDomainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsCreate_564239(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customDomainName` field"
  var valid_564241 = path.getOrDefault("customDomainName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "customDomainName", valid_564241
  var valid_564242 = path.getOrDefault("profileName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "profileName", valid_564242
  var valid_564243 = path.getOrDefault("subscriptionId")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "subscriptionId", valid_564243
  var valid_564244 = path.getOrDefault("resourceGroupName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "resourceGroupName", valid_564244
  var valid_564245 = path.getOrDefault("endpointName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "endpointName", valid_564245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564246 = query.getOrDefault("api-version")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "api-version", valid_564246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain properties required for creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564248: Call_CustomDomainsCreate_564238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564248.validator(path, query, header, formData, body)
  let scheme = call_564248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564248.url(scheme.get, call_564248.host, call_564248.base,
                         call_564248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564248, url, valid)

proc call*(call_564249: Call_CustomDomainsCreate_564238; customDomainName: string;
          profileName: string; apiVersion: string; customDomainProperties: JsonNode;
          subscriptionId: string; resourceGroupName: string; endpointName: string): Recallable =
  ## customDomainsCreate
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain properties required for creation.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564250 = newJObject()
  var query_564251 = newJObject()
  var body_564252 = newJObject()
  add(path_564250, "customDomainName", newJString(customDomainName))
  add(path_564250, "profileName", newJString(profileName))
  add(query_564251, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_564252 = customDomainProperties
  add(path_564250, "subscriptionId", newJString(subscriptionId))
  add(path_564250, "resourceGroupName", newJString(resourceGroupName))
  add(path_564250, "endpointName", newJString(endpointName))
  result = call_564249.call(path_564250, query_564251, nil, nil, body_564252)

var customDomainsCreate* = Call_CustomDomainsCreate_564238(
    name: "customDomainsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsCreate_564239, base: "",
    url: url_CustomDomainsCreate_564240, schemes: {Scheme.Https})
type
  Call_CustomDomainsGet_564225 = ref object of OpenApiRestCall_563540
proc url_CustomDomainsGet_564227(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "customDomainName" in path,
        "`customDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains/"),
               (kind: VariableSegment, value: "customDomainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsGet_564226(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customDomainName` field"
  var valid_564228 = path.getOrDefault("customDomainName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "customDomainName", valid_564228
  var valid_564229 = path.getOrDefault("profileName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "profileName", valid_564229
  var valid_564230 = path.getOrDefault("subscriptionId")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "subscriptionId", valid_564230
  var valid_564231 = path.getOrDefault("resourceGroupName")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "resourceGroupName", valid_564231
  var valid_564232 = path.getOrDefault("endpointName")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "endpointName", valid_564232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564233 = query.getOrDefault("api-version")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "api-version", valid_564233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564234: Call_CustomDomainsGet_564225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564234.validator(path, query, header, formData, body)
  let scheme = call_564234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564234.url(scheme.get, call_564234.host, call_564234.base,
                         call_564234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564234, url, valid)

proc call*(call_564235: Call_CustomDomainsGet_564225; customDomainName: string;
          profileName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; endpointName: string): Recallable =
  ## customDomainsGet
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564236 = newJObject()
  var query_564237 = newJObject()
  add(path_564236, "customDomainName", newJString(customDomainName))
  add(path_564236, "profileName", newJString(profileName))
  add(query_564237, "api-version", newJString(apiVersion))
  add(path_564236, "subscriptionId", newJString(subscriptionId))
  add(path_564236, "resourceGroupName", newJString(resourceGroupName))
  add(path_564236, "endpointName", newJString(endpointName))
  result = call_564235.call(path_564236, query_564237, nil, nil, nil)

var customDomainsGet* = Call_CustomDomainsGet_564225(name: "customDomainsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsGet_564226, base: "",
    url: url_CustomDomainsGet_564227, schemes: {Scheme.Https})
type
  Call_CustomDomainsUpdate_564266 = ref object of OpenApiRestCall_563540
proc url_CustomDomainsUpdate_564268(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "customDomainName" in path,
        "`customDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains/"),
               (kind: VariableSegment, value: "customDomainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsUpdate_564267(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customDomainName` field"
  var valid_564269 = path.getOrDefault("customDomainName")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "customDomainName", valid_564269
  var valid_564270 = path.getOrDefault("profileName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "profileName", valid_564270
  var valid_564271 = path.getOrDefault("subscriptionId")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "subscriptionId", valid_564271
  var valid_564272 = path.getOrDefault("resourceGroupName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "resourceGroupName", valid_564272
  var valid_564273 = path.getOrDefault("endpointName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "endpointName", valid_564273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564274 = query.getOrDefault("api-version")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "api-version", valid_564274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain properties to update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564276: Call_CustomDomainsUpdate_564266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564276.validator(path, query, header, formData, body)
  let scheme = call_564276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564276.url(scheme.get, call_564276.host, call_564276.base,
                         call_564276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564276, url, valid)

proc call*(call_564277: Call_CustomDomainsUpdate_564266; customDomainName: string;
          profileName: string; apiVersion: string; customDomainProperties: JsonNode;
          subscriptionId: string; resourceGroupName: string; endpointName: string): Recallable =
  ## customDomainsUpdate
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain properties to update.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564278 = newJObject()
  var query_564279 = newJObject()
  var body_564280 = newJObject()
  add(path_564278, "customDomainName", newJString(customDomainName))
  add(path_564278, "profileName", newJString(profileName))
  add(query_564279, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_564280 = customDomainProperties
  add(path_564278, "subscriptionId", newJString(subscriptionId))
  add(path_564278, "resourceGroupName", newJString(resourceGroupName))
  add(path_564278, "endpointName", newJString(endpointName))
  result = call_564277.call(path_564278, query_564279, nil, nil, body_564280)

var customDomainsUpdate* = Call_CustomDomainsUpdate_564266(
    name: "customDomainsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsUpdate_564267, base: "",
    url: url_CustomDomainsUpdate_564268, schemes: {Scheme.Https})
type
  Call_CustomDomainsDeleteIfExists_564253 = ref object of OpenApiRestCall_563540
proc url_CustomDomainsDeleteIfExists_564255(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "customDomainName" in path,
        "`customDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains/"),
               (kind: VariableSegment, value: "customDomainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsDeleteIfExists_564254(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customDomainName` field"
  var valid_564256 = path.getOrDefault("customDomainName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "customDomainName", valid_564256
  var valid_564257 = path.getOrDefault("profileName")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "profileName", valid_564257
  var valid_564258 = path.getOrDefault("subscriptionId")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "subscriptionId", valid_564258
  var valid_564259 = path.getOrDefault("resourceGroupName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "resourceGroupName", valid_564259
  var valid_564260 = path.getOrDefault("endpointName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "endpointName", valid_564260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564261 = query.getOrDefault("api-version")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "api-version", valid_564261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564262: Call_CustomDomainsDeleteIfExists_564253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564262.validator(path, query, header, formData, body)
  let scheme = call_564262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564262.url(scheme.get, call_564262.host, call_564262.base,
                         call_564262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564262, url, valid)

proc call*(call_564263: Call_CustomDomainsDeleteIfExists_564253;
          customDomainName: string; profileName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; endpointName: string): Recallable =
  ## customDomainsDeleteIfExists
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564264 = newJObject()
  var query_564265 = newJObject()
  add(path_564264, "customDomainName", newJString(customDomainName))
  add(path_564264, "profileName", newJString(profileName))
  add(query_564265, "api-version", newJString(apiVersion))
  add(path_564264, "subscriptionId", newJString(subscriptionId))
  add(path_564264, "resourceGroupName", newJString(resourceGroupName))
  add(path_564264, "endpointName", newJString(endpointName))
  result = call_564263.call(path_564264, query_564265, nil, nil, nil)

var customDomainsDeleteIfExists* = Call_CustomDomainsDeleteIfExists_564253(
    name: "customDomainsDeleteIfExists", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsDeleteIfExists_564254, base: "",
    url: url_CustomDomainsDeleteIfExists_564255, schemes: {Scheme.Https})
type
  Call_EndpointsLoadContent_564281 = ref object of OpenApiRestCall_563540
proc url_EndpointsLoadContent_564283(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/load")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsLoadContent_564282(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564284 = path.getOrDefault("profileName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "profileName", valid_564284
  var valid_564285 = path.getOrDefault("subscriptionId")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "subscriptionId", valid_564285
  var valid_564286 = path.getOrDefault("resourceGroupName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "resourceGroupName", valid_564286
  var valid_564287 = path.getOrDefault("endpointName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "endpointName", valid_564287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564288 = query.getOrDefault("api-version")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "api-version", valid_564288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be loaded. Path should describe a file.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564290: Call_EndpointsLoadContent_564281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564290.validator(path, query, header, formData, body)
  let scheme = call_564290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564290.url(scheme.get, call_564290.host, call_564290.base,
                         call_564290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564290, url, valid)

proc call*(call_564291: Call_EndpointsLoadContent_564281;
          contentFilePaths: JsonNode; profileName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; endpointName: string): Recallable =
  ## endpointsLoadContent
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be loaded. Path should describe a file.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564292 = newJObject()
  var query_564293 = newJObject()
  var body_564294 = newJObject()
  if contentFilePaths != nil:
    body_564294 = contentFilePaths
  add(path_564292, "profileName", newJString(profileName))
  add(query_564293, "api-version", newJString(apiVersion))
  add(path_564292, "subscriptionId", newJString(subscriptionId))
  add(path_564292, "resourceGroupName", newJString(resourceGroupName))
  add(path_564292, "endpointName", newJString(endpointName))
  result = call_564291.call(path_564292, query_564293, nil, nil, body_564294)

var endpointsLoadContent* = Call_EndpointsLoadContent_564281(
    name: "endpointsLoadContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/load",
    validator: validate_EndpointsLoadContent_564282, base: "",
    url: url_EndpointsLoadContent_564283, schemes: {Scheme.Https})
type
  Call_OriginsListByEndpoint_564295 = ref object of OpenApiRestCall_563540
proc url_OriginsListByEndpoint_564297(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/origins")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OriginsListByEndpoint_564296(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564298 = path.getOrDefault("profileName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "profileName", valid_564298
  var valid_564299 = path.getOrDefault("subscriptionId")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "subscriptionId", valid_564299
  var valid_564300 = path.getOrDefault("resourceGroupName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "resourceGroupName", valid_564300
  var valid_564301 = path.getOrDefault("endpointName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "endpointName", valid_564301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564302 = query.getOrDefault("api-version")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "api-version", valid_564302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564303: Call_OriginsListByEndpoint_564295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564303.validator(path, query, header, formData, body)
  let scheme = call_564303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564303.url(scheme.get, call_564303.host, call_564303.base,
                         call_564303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564303, url, valid)

proc call*(call_564304: Call_OriginsListByEndpoint_564295; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          endpointName: string): Recallable =
  ## originsListByEndpoint
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564305 = newJObject()
  var query_564306 = newJObject()
  add(path_564305, "profileName", newJString(profileName))
  add(query_564306, "api-version", newJString(apiVersion))
  add(path_564305, "subscriptionId", newJString(subscriptionId))
  add(path_564305, "resourceGroupName", newJString(resourceGroupName))
  add(path_564305, "endpointName", newJString(endpointName))
  result = call_564304.call(path_564305, query_564306, nil, nil, nil)

var originsListByEndpoint* = Call_OriginsListByEndpoint_564295(
    name: "originsListByEndpoint", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins",
    validator: validate_OriginsListByEndpoint_564296, base: "",
    url: url_OriginsListByEndpoint_564297, schemes: {Scheme.Https})
type
  Call_OriginsCreate_564320 = ref object of OpenApiRestCall_563540
proc url_OriginsCreate_564322(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "originName" in path, "`originName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/origins/"),
               (kind: VariableSegment, value: "originName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OriginsCreate_564321(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   originName: JString (required)
  ##             : Name of the origin, an arbitrary value but it needs to be unique under endpoint
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564323 = path.getOrDefault("profileName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "profileName", valid_564323
  var valid_564324 = path.getOrDefault("subscriptionId")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "subscriptionId", valid_564324
  var valid_564325 = path.getOrDefault("resourceGroupName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "resourceGroupName", valid_564325
  var valid_564326 = path.getOrDefault("originName")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "originName", valid_564326
  var valid_564327 = path.getOrDefault("endpointName")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "endpointName", valid_564327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564328 = query.getOrDefault("api-version")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "api-version", valid_564328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   originProperties: JObject (required)
  ##                   : Origin properties
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564330: Call_OriginsCreate_564320; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564330.validator(path, query, header, formData, body)
  let scheme = call_564330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564330.url(scheme.get, call_564330.host, call_564330.base,
                         call_564330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564330, url, valid)

proc call*(call_564331: Call_OriginsCreate_564320; profileName: string;
          apiVersion: string; subscriptionId: string; originProperties: JsonNode;
          resourceGroupName: string; originName: string; endpointName: string): Recallable =
  ## originsCreate
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   originProperties: JObject (required)
  ##                   : Origin properties
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   originName: string (required)
  ##             : Name of the origin, an arbitrary value but it needs to be unique under endpoint
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564332 = newJObject()
  var query_564333 = newJObject()
  var body_564334 = newJObject()
  add(path_564332, "profileName", newJString(profileName))
  add(query_564333, "api-version", newJString(apiVersion))
  add(path_564332, "subscriptionId", newJString(subscriptionId))
  if originProperties != nil:
    body_564334 = originProperties
  add(path_564332, "resourceGroupName", newJString(resourceGroupName))
  add(path_564332, "originName", newJString(originName))
  add(path_564332, "endpointName", newJString(endpointName))
  result = call_564331.call(path_564332, query_564333, nil, nil, body_564334)

var originsCreate* = Call_OriginsCreate_564320(name: "originsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
    validator: validate_OriginsCreate_564321, base: "", url: url_OriginsCreate_564322,
    schemes: {Scheme.Https})
type
  Call_OriginsGet_564307 = ref object of OpenApiRestCall_563540
proc url_OriginsGet_564309(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "originName" in path, "`originName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/origins/"),
               (kind: VariableSegment, value: "originName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OriginsGet_564308(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   originName: JString (required)
  ##             : Name of the origin, an arbitrary value but it needs to be unique under endpoint
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564310 = path.getOrDefault("profileName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "profileName", valid_564310
  var valid_564311 = path.getOrDefault("subscriptionId")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "subscriptionId", valid_564311
  var valid_564312 = path.getOrDefault("resourceGroupName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "resourceGroupName", valid_564312
  var valid_564313 = path.getOrDefault("originName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "originName", valid_564313
  var valid_564314 = path.getOrDefault("endpointName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "endpointName", valid_564314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564315 = query.getOrDefault("api-version")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "api-version", valid_564315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564316: Call_OriginsGet_564307; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564316.validator(path, query, header, formData, body)
  let scheme = call_564316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564316.url(scheme.get, call_564316.host, call_564316.base,
                         call_564316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564316, url, valid)

proc call*(call_564317: Call_OriginsGet_564307; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          originName: string; endpointName: string): Recallable =
  ## originsGet
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   originName: string (required)
  ##             : Name of the origin, an arbitrary value but it needs to be unique under endpoint
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564318 = newJObject()
  var query_564319 = newJObject()
  add(path_564318, "profileName", newJString(profileName))
  add(query_564319, "api-version", newJString(apiVersion))
  add(path_564318, "subscriptionId", newJString(subscriptionId))
  add(path_564318, "resourceGroupName", newJString(resourceGroupName))
  add(path_564318, "originName", newJString(originName))
  add(path_564318, "endpointName", newJString(endpointName))
  result = call_564317.call(path_564318, query_564319, nil, nil, nil)

var originsGet* = Call_OriginsGet_564307(name: "originsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
                                      validator: validate_OriginsGet_564308,
                                      base: "", url: url_OriginsGet_564309,
                                      schemes: {Scheme.Https})
type
  Call_OriginsUpdate_564348 = ref object of OpenApiRestCall_563540
proc url_OriginsUpdate_564350(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "originName" in path, "`originName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/origins/"),
               (kind: VariableSegment, value: "originName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OriginsUpdate_564349(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   originName: JString (required)
  ##             : Name of the origin. Must be unique within endpoint.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564351 = path.getOrDefault("profileName")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "profileName", valid_564351
  var valid_564352 = path.getOrDefault("subscriptionId")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "subscriptionId", valid_564352
  var valid_564353 = path.getOrDefault("resourceGroupName")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "resourceGroupName", valid_564353
  var valid_564354 = path.getOrDefault("originName")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "originName", valid_564354
  var valid_564355 = path.getOrDefault("endpointName")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "endpointName", valid_564355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564356 = query.getOrDefault("api-version")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "api-version", valid_564356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   originProperties: JObject (required)
  ##                   : Origin properties
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564358: Call_OriginsUpdate_564348; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564358.validator(path, query, header, formData, body)
  let scheme = call_564358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564358.url(scheme.get, call_564358.host, call_564358.base,
                         call_564358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564358, url, valid)

proc call*(call_564359: Call_OriginsUpdate_564348; profileName: string;
          apiVersion: string; subscriptionId: string; originProperties: JsonNode;
          resourceGroupName: string; originName: string; endpointName: string): Recallable =
  ## originsUpdate
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   originProperties: JObject (required)
  ##                   : Origin properties
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   originName: string (required)
  ##             : Name of the origin. Must be unique within endpoint.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564360 = newJObject()
  var query_564361 = newJObject()
  var body_564362 = newJObject()
  add(path_564360, "profileName", newJString(profileName))
  add(query_564361, "api-version", newJString(apiVersion))
  add(path_564360, "subscriptionId", newJString(subscriptionId))
  if originProperties != nil:
    body_564362 = originProperties
  add(path_564360, "resourceGroupName", newJString(resourceGroupName))
  add(path_564360, "originName", newJString(originName))
  add(path_564360, "endpointName", newJString(endpointName))
  result = call_564359.call(path_564360, query_564361, nil, nil, body_564362)

var originsUpdate* = Call_OriginsUpdate_564348(name: "originsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
    validator: validate_OriginsUpdate_564349, base: "", url: url_OriginsUpdate_564350,
    schemes: {Scheme.Https})
type
  Call_OriginsDeleteIfExists_564335 = ref object of OpenApiRestCall_563540
proc url_OriginsDeleteIfExists_564337(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "originName" in path, "`originName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/origins/"),
               (kind: VariableSegment, value: "originName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OriginsDeleteIfExists_564336(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   originName: JString (required)
  ##             : Name of the origin. Must be unique within endpoint.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564338 = path.getOrDefault("profileName")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "profileName", valid_564338
  var valid_564339 = path.getOrDefault("subscriptionId")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "subscriptionId", valid_564339
  var valid_564340 = path.getOrDefault("resourceGroupName")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "resourceGroupName", valid_564340
  var valid_564341 = path.getOrDefault("originName")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "originName", valid_564341
  var valid_564342 = path.getOrDefault("endpointName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "endpointName", valid_564342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564343 = query.getOrDefault("api-version")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "api-version", valid_564343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564344: Call_OriginsDeleteIfExists_564335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564344.validator(path, query, header, formData, body)
  let scheme = call_564344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564344.url(scheme.get, call_564344.host, call_564344.base,
                         call_564344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564344, url, valid)

proc call*(call_564345: Call_OriginsDeleteIfExists_564335; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          originName: string; endpointName: string): Recallable =
  ## originsDeleteIfExists
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   originName: string (required)
  ##             : Name of the origin. Must be unique within endpoint.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564346 = newJObject()
  var query_564347 = newJObject()
  add(path_564346, "profileName", newJString(profileName))
  add(query_564347, "api-version", newJString(apiVersion))
  add(path_564346, "subscriptionId", newJString(subscriptionId))
  add(path_564346, "resourceGroupName", newJString(resourceGroupName))
  add(path_564346, "originName", newJString(originName))
  add(path_564346, "endpointName", newJString(endpointName))
  result = call_564345.call(path_564346, query_564347, nil, nil, nil)

var originsDeleteIfExists* = Call_OriginsDeleteIfExists_564335(
    name: "originsDeleteIfExists", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
    validator: validate_OriginsDeleteIfExists_564336, base: "",
    url: url_OriginsDeleteIfExists_564337, schemes: {Scheme.Https})
type
  Call_EndpointsPurgeContent_564363 = ref object of OpenApiRestCall_563540
proc url_EndpointsPurgeContent_564365(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/purge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsPurgeContent_564364(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564366 = path.getOrDefault("profileName")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "profileName", valid_564366
  var valid_564367 = path.getOrDefault("subscriptionId")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "subscriptionId", valid_564367
  var valid_564368 = path.getOrDefault("resourceGroupName")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "resourceGroupName", valid_564368
  var valid_564369 = path.getOrDefault("endpointName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "endpointName", valid_564369
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564370 = query.getOrDefault("api-version")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "api-version", valid_564370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be purged. Path can describe a file or directory.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564372: Call_EndpointsPurgeContent_564363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564372.validator(path, query, header, formData, body)
  let scheme = call_564372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564372.url(scheme.get, call_564372.host, call_564372.base,
                         call_564372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564372, url, valid)

proc call*(call_564373: Call_EndpointsPurgeContent_564363;
          contentFilePaths: JsonNode; profileName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; endpointName: string): Recallable =
  ## endpointsPurgeContent
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be purged. Path can describe a file or directory.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564374 = newJObject()
  var query_564375 = newJObject()
  var body_564376 = newJObject()
  if contentFilePaths != nil:
    body_564376 = contentFilePaths
  add(path_564374, "profileName", newJString(profileName))
  add(query_564375, "api-version", newJString(apiVersion))
  add(path_564374, "subscriptionId", newJString(subscriptionId))
  add(path_564374, "resourceGroupName", newJString(resourceGroupName))
  add(path_564374, "endpointName", newJString(endpointName))
  result = call_564373.call(path_564374, query_564375, nil, nil, body_564376)

var endpointsPurgeContent* = Call_EndpointsPurgeContent_564363(
    name: "endpointsPurgeContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/purge",
    validator: validate_EndpointsPurgeContent_564364, base: "",
    url: url_EndpointsPurgeContent_564365, schemes: {Scheme.Https})
type
  Call_EndpointsStart_564377 = ref object of OpenApiRestCall_563540
proc url_EndpointsStart_564379(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsStart_564378(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564380 = path.getOrDefault("profileName")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "profileName", valid_564380
  var valid_564381 = path.getOrDefault("subscriptionId")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "subscriptionId", valid_564381
  var valid_564382 = path.getOrDefault("resourceGroupName")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "resourceGroupName", valid_564382
  var valid_564383 = path.getOrDefault("endpointName")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "endpointName", valid_564383
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564384 = query.getOrDefault("api-version")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "api-version", valid_564384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564385: Call_EndpointsStart_564377; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564385.validator(path, query, header, formData, body)
  let scheme = call_564385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564385.url(scheme.get, call_564385.host, call_564385.base,
                         call_564385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564385, url, valid)

proc call*(call_564386: Call_EndpointsStart_564377; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          endpointName: string): Recallable =
  ## endpointsStart
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564387 = newJObject()
  var query_564388 = newJObject()
  add(path_564387, "profileName", newJString(profileName))
  add(query_564388, "api-version", newJString(apiVersion))
  add(path_564387, "subscriptionId", newJString(subscriptionId))
  add(path_564387, "resourceGroupName", newJString(resourceGroupName))
  add(path_564387, "endpointName", newJString(endpointName))
  result = call_564386.call(path_564387, query_564388, nil, nil, nil)

var endpointsStart* = Call_EndpointsStart_564377(name: "endpointsStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/start",
    validator: validate_EndpointsStart_564378, base: "", url: url_EndpointsStart_564379,
    schemes: {Scheme.Https})
type
  Call_EndpointsStop_564389 = ref object of OpenApiRestCall_563540
proc url_EndpointsStop_564391(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsStop_564390(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564392 = path.getOrDefault("profileName")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "profileName", valid_564392
  var valid_564393 = path.getOrDefault("subscriptionId")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "subscriptionId", valid_564393
  var valid_564394 = path.getOrDefault("resourceGroupName")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "resourceGroupName", valid_564394
  var valid_564395 = path.getOrDefault("endpointName")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "endpointName", valid_564395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564396 = query.getOrDefault("api-version")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "api-version", valid_564396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564397: Call_EndpointsStop_564389; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564397.validator(path, query, header, formData, body)
  let scheme = call_564397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564397.url(scheme.get, call_564397.host, call_564397.base,
                         call_564397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564397, url, valid)

proc call*(call_564398: Call_EndpointsStop_564389; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          endpointName: string): Recallable =
  ## endpointsStop
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564399 = newJObject()
  var query_564400 = newJObject()
  add(path_564399, "profileName", newJString(profileName))
  add(query_564400, "api-version", newJString(apiVersion))
  add(path_564399, "subscriptionId", newJString(subscriptionId))
  add(path_564399, "resourceGroupName", newJString(resourceGroupName))
  add(path_564399, "endpointName", newJString(endpointName))
  result = call_564398.call(path_564399, query_564400, nil, nil, nil)

var endpointsStop* = Call_EndpointsStop_564389(name: "endpointsStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/stop",
    validator: validate_EndpointsStop_564390, base: "", url: url_EndpointsStop_564391,
    schemes: {Scheme.Https})
type
  Call_EndpointsValidateCustomDomain_564401 = ref object of OpenApiRestCall_563540
proc url_EndpointsValidateCustomDomain_564403(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/validateCustomDomain")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsValidateCustomDomain_564402(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564404 = path.getOrDefault("profileName")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "profileName", valid_564404
  var valid_564405 = path.getOrDefault("subscriptionId")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "subscriptionId", valid_564405
  var valid_564406 = path.getOrDefault("resourceGroupName")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "resourceGroupName", valid_564406
  var valid_564407 = path.getOrDefault("endpointName")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "endpointName", valid_564407
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564408 = query.getOrDefault("api-version")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "api-version", valid_564408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain to validate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564410: Call_EndpointsValidateCustomDomain_564401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564410.validator(path, query, header, formData, body)
  let scheme = call_564410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564410.url(scheme.get, call_564410.host, call_564410.base,
                         call_564410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564410, url, valid)

proc call*(call_564411: Call_EndpointsValidateCustomDomain_564401;
          profileName: string; apiVersion: string; customDomainProperties: JsonNode;
          subscriptionId: string; resourceGroupName: string; endpointName: string): Recallable =
  ## endpointsValidateCustomDomain
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain to validate.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_564412 = newJObject()
  var query_564413 = newJObject()
  var body_564414 = newJObject()
  add(path_564412, "profileName", newJString(profileName))
  add(query_564413, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_564414 = customDomainProperties
  add(path_564412, "subscriptionId", newJString(subscriptionId))
  add(path_564412, "resourceGroupName", newJString(resourceGroupName))
  add(path_564412, "endpointName", newJString(endpointName))
  result = call_564411.call(path_564412, query_564413, nil, nil, body_564414)

var endpointsValidateCustomDomain* = Call_EndpointsValidateCustomDomain_564401(
    name: "endpointsValidateCustomDomain", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/validateCustomDomain",
    validator: validate_EndpointsValidateCustomDomain_564402, base: "",
    url: url_EndpointsValidateCustomDomain_564403, schemes: {Scheme.Https})
type
  Call_ProfilesGenerateSsoUri_564415 = ref object of OpenApiRestCall_563540
proc url_ProfilesGenerateSsoUri_564417(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/generateSsoUri")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesGenerateSsoUri_564416(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564418 = path.getOrDefault("profileName")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "profileName", valid_564418
  var valid_564419 = path.getOrDefault("subscriptionId")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "subscriptionId", valid_564419
  var valid_564420 = path.getOrDefault("resourceGroupName")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "resourceGroupName", valid_564420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564421 = query.getOrDefault("api-version")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "api-version", valid_564421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564422: Call_ProfilesGenerateSsoUri_564415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564422.validator(path, query, header, formData, body)
  let scheme = call_564422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564422.url(scheme.get, call_564422.host, call_564422.base,
                         call_564422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564422, url, valid)

proc call*(call_564423: Call_ProfilesGenerateSsoUri_564415; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## profilesGenerateSsoUri
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564424 = newJObject()
  var query_564425 = newJObject()
  add(path_564424, "profileName", newJString(profileName))
  add(query_564425, "api-version", newJString(apiVersion))
  add(path_564424, "subscriptionId", newJString(subscriptionId))
  add(path_564424, "resourceGroupName", newJString(resourceGroupName))
  result = call_564423.call(path_564424, query_564425, nil, nil, nil)

var profilesGenerateSsoUri* = Call_ProfilesGenerateSsoUri_564415(
    name: "profilesGenerateSsoUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/generateSsoUri",
    validator: validate_ProfilesGenerateSsoUri_564416, base: "",
    url: url_ProfilesGenerateSsoUri_564417, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
