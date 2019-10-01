
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_574442 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574442](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574442): Option[Scheme] {.used.} =
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
  macServiceName = "cdn"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_NameAvailabilityCheckNameAvailability_574664 = ref object of OpenApiRestCall_574442
proc url_NameAvailabilityCheckNameAvailability_574666(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_NameAvailabilityCheckNameAvailability_574665(path: JsonNode;
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
  var valid_574825 = query.getOrDefault("api-version")
  valid_574825 = validateParameter(valid_574825, JString, required = true,
                                 default = nil)
  if valid_574825 != nil:
    section.add "api-version", valid_574825
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

proc call*(call_574849: Call_NameAvailabilityCheckNameAvailability_574664;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_574849.validator(path, query, header, formData, body)
  let scheme = call_574849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574849.url(scheme.get, call_574849.host, call_574849.base,
                         call_574849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574849, url, valid)

proc call*(call_574920: Call_NameAvailabilityCheckNameAvailability_574664;
          apiVersion: string; checkNameAvailabilityInput: JsonNode): Recallable =
  ## nameAvailabilityCheckNameAvailability
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   checkNameAvailabilityInput: JObject (required)
  ##                             : Input to check.
  var query_574921 = newJObject()
  var body_574923 = newJObject()
  add(query_574921, "api-version", newJString(apiVersion))
  if checkNameAvailabilityInput != nil:
    body_574923 = checkNameAvailabilityInput
  result = call_574920.call(nil, query_574921, nil, nil, body_574923)

var nameAvailabilityCheckNameAvailability* = Call_NameAvailabilityCheckNameAvailability_574664(
    name: "nameAvailabilityCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Cdn/checkNameAvailability",
    validator: validate_NameAvailabilityCheckNameAvailability_574665, base: "",
    url: url_NameAvailabilityCheckNameAvailability_574666, schemes: {Scheme.Https})
type
  Call_OperationsList_574962 = ref object of OpenApiRestCall_574442
proc url_OperationsList_574964(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_574963(path: JsonNode; query: JsonNode;
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
  var valid_574965 = query.getOrDefault("api-version")
  valid_574965 = validateParameter(valid_574965, JString, required = true,
                                 default = nil)
  if valid_574965 != nil:
    section.add "api-version", valid_574965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574966: Call_OperationsList_574962; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574966.validator(path, query, header, formData, body)
  let scheme = call_574966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574966.url(scheme.get, call_574966.host, call_574966.base,
                         call_574966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574966, url, valid)

proc call*(call_574967: Call_OperationsList_574962; apiVersion: string): Recallable =
  ## operationsList
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  var query_574968 = newJObject()
  add(query_574968, "api-version", newJString(apiVersion))
  result = call_574967.call(nil, query_574968, nil, nil, nil)

var operationsList* = Call_OperationsList_574962(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Cdn/operations",
    validator: validate_OperationsList_574963, base: "", url: url_OperationsList_574964,
    schemes: {Scheme.Https})
type
  Call_ProfilesListBySubscriptionId_574969 = ref object of OpenApiRestCall_574442
proc url_ProfilesListBySubscriptionId_574971(protocol: Scheme; host: string;
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

proc validate_ProfilesListBySubscriptionId_574970(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574986 = path.getOrDefault("subscriptionId")
  valid_574986 = validateParameter(valid_574986, JString, required = true,
                                 default = nil)
  if valid_574986 != nil:
    section.add "subscriptionId", valid_574986
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574987 = query.getOrDefault("api-version")
  valid_574987 = validateParameter(valid_574987, JString, required = true,
                                 default = nil)
  if valid_574987 != nil:
    section.add "api-version", valid_574987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574988: Call_ProfilesListBySubscriptionId_574969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574988.validator(path, query, header, formData, body)
  let scheme = call_574988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574988.url(scheme.get, call_574988.host, call_574988.base,
                         call_574988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574988, url, valid)

proc call*(call_574989: Call_ProfilesListBySubscriptionId_574969;
          apiVersion: string; subscriptionId: string): Recallable =
  ## profilesListBySubscriptionId
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_574990 = newJObject()
  var query_574991 = newJObject()
  add(query_574991, "api-version", newJString(apiVersion))
  add(path_574990, "subscriptionId", newJString(subscriptionId))
  result = call_574989.call(path_574990, query_574991, nil, nil, nil)

var profilesListBySubscriptionId* = Call_ProfilesListBySubscriptionId_574969(
    name: "profilesListBySubscriptionId", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/profiles",
    validator: validate_ProfilesListBySubscriptionId_574970, base: "",
    url: url_ProfilesListBySubscriptionId_574971, schemes: {Scheme.Https})
type
  Call_ProfilesListByResourceGroup_574992 = ref object of OpenApiRestCall_574442
proc url_ProfilesListByResourceGroup_574994(protocol: Scheme; host: string;
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

proc validate_ProfilesListByResourceGroup_574993(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574995 = path.getOrDefault("resourceGroupName")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "resourceGroupName", valid_574995
  var valid_574996 = path.getOrDefault("subscriptionId")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "subscriptionId", valid_574996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574997 = query.getOrDefault("api-version")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = nil)
  if valid_574997 != nil:
    section.add "api-version", valid_574997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574998: Call_ProfilesListByResourceGroup_574992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574998.validator(path, query, header, formData, body)
  let scheme = call_574998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574998.url(scheme.get, call_574998.host, call_574998.base,
                         call_574998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574998, url, valid)

proc call*(call_574999: Call_ProfilesListByResourceGroup_574992;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## profilesListByResourceGroup
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575000 = newJObject()
  var query_575001 = newJObject()
  add(path_575000, "resourceGroupName", newJString(resourceGroupName))
  add(query_575001, "api-version", newJString(apiVersion))
  add(path_575000, "subscriptionId", newJString(subscriptionId))
  result = call_574999.call(path_575000, query_575001, nil, nil, nil)

var profilesListByResourceGroup* = Call_ProfilesListByResourceGroup_574992(
    name: "profilesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles",
    validator: validate_ProfilesListByResourceGroup_574993, base: "",
    url: url_ProfilesListByResourceGroup_574994, schemes: {Scheme.Https})
type
  Call_ProfilesCreate_575013 = ref object of OpenApiRestCall_574442
proc url_ProfilesCreate_575015(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesCreate_575014(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575016 = path.getOrDefault("resourceGroupName")
  valid_575016 = validateParameter(valid_575016, JString, required = true,
                                 default = nil)
  if valid_575016 != nil:
    section.add "resourceGroupName", valid_575016
  var valid_575017 = path.getOrDefault("subscriptionId")
  valid_575017 = validateParameter(valid_575017, JString, required = true,
                                 default = nil)
  if valid_575017 != nil:
    section.add "subscriptionId", valid_575017
  var valid_575018 = path.getOrDefault("profileName")
  valid_575018 = validateParameter(valid_575018, JString, required = true,
                                 default = nil)
  if valid_575018 != nil:
    section.add "profileName", valid_575018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575019 = query.getOrDefault("api-version")
  valid_575019 = validateParameter(valid_575019, JString, required = true,
                                 default = nil)
  if valid_575019 != nil:
    section.add "api-version", valid_575019
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

proc call*(call_575021: Call_ProfilesCreate_575013; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575021.validator(path, query, header, formData, body)
  let scheme = call_575021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575021.url(scheme.get, call_575021.host, call_575021.base,
                         call_575021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575021, url, valid)

proc call*(call_575022: Call_ProfilesCreate_575013; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileProperties: JsonNode;
          profileName: string): Recallable =
  ## profilesCreate
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileProperties: JObject (required)
  ##                    : Profile properties needed for creation.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  var path_575023 = newJObject()
  var query_575024 = newJObject()
  var body_575025 = newJObject()
  add(path_575023, "resourceGroupName", newJString(resourceGroupName))
  add(query_575024, "api-version", newJString(apiVersion))
  add(path_575023, "subscriptionId", newJString(subscriptionId))
  if profileProperties != nil:
    body_575025 = profileProperties
  add(path_575023, "profileName", newJString(profileName))
  result = call_575022.call(path_575023, query_575024, nil, nil, body_575025)

var profilesCreate* = Call_ProfilesCreate_575013(name: "profilesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesCreate_575014, base: "", url: url_ProfilesCreate_575015,
    schemes: {Scheme.Https})
type
  Call_ProfilesGet_575002 = ref object of OpenApiRestCall_574442
proc url_ProfilesGet_575004(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesGet_575003(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575005 = path.getOrDefault("resourceGroupName")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = nil)
  if valid_575005 != nil:
    section.add "resourceGroupName", valid_575005
  var valid_575006 = path.getOrDefault("subscriptionId")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = nil)
  if valid_575006 != nil:
    section.add "subscriptionId", valid_575006
  var valid_575007 = path.getOrDefault("profileName")
  valid_575007 = validateParameter(valid_575007, JString, required = true,
                                 default = nil)
  if valid_575007 != nil:
    section.add "profileName", valid_575007
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575008 = query.getOrDefault("api-version")
  valid_575008 = validateParameter(valid_575008, JString, required = true,
                                 default = nil)
  if valid_575008 != nil:
    section.add "api-version", valid_575008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575009: Call_ProfilesGet_575002; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575009.validator(path, query, header, formData, body)
  let scheme = call_575009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575009.url(scheme.get, call_575009.host, call_575009.base,
                         call_575009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575009, url, valid)

proc call*(call_575010: Call_ProfilesGet_575002; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string): Recallable =
  ## profilesGet
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  var path_575011 = newJObject()
  var query_575012 = newJObject()
  add(path_575011, "resourceGroupName", newJString(resourceGroupName))
  add(query_575012, "api-version", newJString(apiVersion))
  add(path_575011, "subscriptionId", newJString(subscriptionId))
  add(path_575011, "profileName", newJString(profileName))
  result = call_575010.call(path_575011, query_575012, nil, nil, nil)

var profilesGet* = Call_ProfilesGet_575002(name: "profilesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
                                        validator: validate_ProfilesGet_575003,
                                        base: "", url: url_ProfilesGet_575004,
                                        schemes: {Scheme.Https})
type
  Call_ProfilesUpdate_575037 = ref object of OpenApiRestCall_574442
proc url_ProfilesUpdate_575039(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesUpdate_575038(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575040 = path.getOrDefault("resourceGroupName")
  valid_575040 = validateParameter(valid_575040, JString, required = true,
                                 default = nil)
  if valid_575040 != nil:
    section.add "resourceGroupName", valid_575040
  var valid_575041 = path.getOrDefault("subscriptionId")
  valid_575041 = validateParameter(valid_575041, JString, required = true,
                                 default = nil)
  if valid_575041 != nil:
    section.add "subscriptionId", valid_575041
  var valid_575042 = path.getOrDefault("profileName")
  valid_575042 = validateParameter(valid_575042, JString, required = true,
                                 default = nil)
  if valid_575042 != nil:
    section.add "profileName", valid_575042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575043 = query.getOrDefault("api-version")
  valid_575043 = validateParameter(valid_575043, JString, required = true,
                                 default = nil)
  if valid_575043 != nil:
    section.add "api-version", valid_575043
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

proc call*(call_575045: Call_ProfilesUpdate_575037; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575045.validator(path, query, header, formData, body)
  let scheme = call_575045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575045.url(scheme.get, call_575045.host, call_575045.base,
                         call_575045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575045, url, valid)

proc call*(call_575046: Call_ProfilesUpdate_575037; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileProperties: JsonNode;
          profileName: string): Recallable =
  ## profilesUpdate
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileProperties: JObject (required)
  ##                    : Profile properties needed for update.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  var path_575047 = newJObject()
  var query_575048 = newJObject()
  var body_575049 = newJObject()
  add(path_575047, "resourceGroupName", newJString(resourceGroupName))
  add(query_575048, "api-version", newJString(apiVersion))
  add(path_575047, "subscriptionId", newJString(subscriptionId))
  if profileProperties != nil:
    body_575049 = profileProperties
  add(path_575047, "profileName", newJString(profileName))
  result = call_575046.call(path_575047, query_575048, nil, nil, body_575049)

var profilesUpdate* = Call_ProfilesUpdate_575037(name: "profilesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesUpdate_575038, base: "", url: url_ProfilesUpdate_575039,
    schemes: {Scheme.Https})
type
  Call_ProfilesDeleteIfExists_575026 = ref object of OpenApiRestCall_574442
proc url_ProfilesDeleteIfExists_575028(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesDeleteIfExists_575027(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575029 = path.getOrDefault("resourceGroupName")
  valid_575029 = validateParameter(valid_575029, JString, required = true,
                                 default = nil)
  if valid_575029 != nil:
    section.add "resourceGroupName", valid_575029
  var valid_575030 = path.getOrDefault("subscriptionId")
  valid_575030 = validateParameter(valid_575030, JString, required = true,
                                 default = nil)
  if valid_575030 != nil:
    section.add "subscriptionId", valid_575030
  var valid_575031 = path.getOrDefault("profileName")
  valid_575031 = validateParameter(valid_575031, JString, required = true,
                                 default = nil)
  if valid_575031 != nil:
    section.add "profileName", valid_575031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575032 = query.getOrDefault("api-version")
  valid_575032 = validateParameter(valid_575032, JString, required = true,
                                 default = nil)
  if valid_575032 != nil:
    section.add "api-version", valid_575032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575033: Call_ProfilesDeleteIfExists_575026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575033.validator(path, query, header, formData, body)
  let scheme = call_575033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575033.url(scheme.get, call_575033.host, call_575033.base,
                         call_575033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575033, url, valid)

proc call*(call_575034: Call_ProfilesDeleteIfExists_575026;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string): Recallable =
  ## profilesDeleteIfExists
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  var path_575035 = newJObject()
  var query_575036 = newJObject()
  add(path_575035, "resourceGroupName", newJString(resourceGroupName))
  add(query_575036, "api-version", newJString(apiVersion))
  add(path_575035, "subscriptionId", newJString(subscriptionId))
  add(path_575035, "profileName", newJString(profileName))
  result = call_575034.call(path_575035, query_575036, nil, nil, nil)

var profilesDeleteIfExists* = Call_ProfilesDeleteIfExists_575026(
    name: "profilesDeleteIfExists", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesDeleteIfExists_575027, base: "",
    url: url_ProfilesDeleteIfExists_575028, schemes: {Scheme.Https})
type
  Call_EndpointsListByProfile_575050 = ref object of OpenApiRestCall_574442
proc url_EndpointsListByProfile_575052(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsListByProfile_575051(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575053 = path.getOrDefault("resourceGroupName")
  valid_575053 = validateParameter(valid_575053, JString, required = true,
                                 default = nil)
  if valid_575053 != nil:
    section.add "resourceGroupName", valid_575053
  var valid_575054 = path.getOrDefault("subscriptionId")
  valid_575054 = validateParameter(valid_575054, JString, required = true,
                                 default = nil)
  if valid_575054 != nil:
    section.add "subscriptionId", valid_575054
  var valid_575055 = path.getOrDefault("profileName")
  valid_575055 = validateParameter(valid_575055, JString, required = true,
                                 default = nil)
  if valid_575055 != nil:
    section.add "profileName", valid_575055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575056 = query.getOrDefault("api-version")
  valid_575056 = validateParameter(valid_575056, JString, required = true,
                                 default = nil)
  if valid_575056 != nil:
    section.add "api-version", valid_575056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575057: Call_EndpointsListByProfile_575050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575057.validator(path, query, header, formData, body)
  let scheme = call_575057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575057.url(scheme.get, call_575057.host, call_575057.base,
                         call_575057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575057, url, valid)

proc call*(call_575058: Call_EndpointsListByProfile_575050;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string): Recallable =
  ## endpointsListByProfile
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  var path_575059 = newJObject()
  var query_575060 = newJObject()
  add(path_575059, "resourceGroupName", newJString(resourceGroupName))
  add(query_575060, "api-version", newJString(apiVersion))
  add(path_575059, "subscriptionId", newJString(subscriptionId))
  add(path_575059, "profileName", newJString(profileName))
  result = call_575058.call(path_575059, query_575060, nil, nil, nil)

var endpointsListByProfile* = Call_EndpointsListByProfile_575050(
    name: "endpointsListByProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints",
    validator: validate_EndpointsListByProfile_575051, base: "",
    url: url_EndpointsListByProfile_575052, schemes: {Scheme.Https})
type
  Call_EndpointsCreate_575073 = ref object of OpenApiRestCall_574442
proc url_EndpointsCreate_575075(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsCreate_575074(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575076 = path.getOrDefault("resourceGroupName")
  valid_575076 = validateParameter(valid_575076, JString, required = true,
                                 default = nil)
  if valid_575076 != nil:
    section.add "resourceGroupName", valid_575076
  var valid_575077 = path.getOrDefault("subscriptionId")
  valid_575077 = validateParameter(valid_575077, JString, required = true,
                                 default = nil)
  if valid_575077 != nil:
    section.add "subscriptionId", valid_575077
  var valid_575078 = path.getOrDefault("profileName")
  valid_575078 = validateParameter(valid_575078, JString, required = true,
                                 default = nil)
  if valid_575078 != nil:
    section.add "profileName", valid_575078
  var valid_575079 = path.getOrDefault("endpointName")
  valid_575079 = validateParameter(valid_575079, JString, required = true,
                                 default = nil)
  if valid_575079 != nil:
    section.add "endpointName", valid_575079
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575080 = query.getOrDefault("api-version")
  valid_575080 = validateParameter(valid_575080, JString, required = true,
                                 default = nil)
  if valid_575080 != nil:
    section.add "api-version", valid_575080
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

proc call*(call_575082: Call_EndpointsCreate_575073; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575082.validator(path, query, header, formData, body)
  let scheme = call_575082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575082.url(scheme.get, call_575082.host, call_575082.base,
                         call_575082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575082, url, valid)

proc call*(call_575083: Call_EndpointsCreate_575073; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; endpointProperties: JsonNode;
          profileName: string; endpointName: string): Recallable =
  ## endpointsCreate
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   endpointProperties: JObject (required)
  ##                     : Endpoint properties
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575084 = newJObject()
  var query_575085 = newJObject()
  var body_575086 = newJObject()
  add(path_575084, "resourceGroupName", newJString(resourceGroupName))
  add(query_575085, "api-version", newJString(apiVersion))
  add(path_575084, "subscriptionId", newJString(subscriptionId))
  if endpointProperties != nil:
    body_575086 = endpointProperties
  add(path_575084, "profileName", newJString(profileName))
  add(path_575084, "endpointName", newJString(endpointName))
  result = call_575083.call(path_575084, query_575085, nil, nil, body_575086)

var endpointsCreate* = Call_EndpointsCreate_575073(name: "endpointsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsCreate_575074, base: "", url: url_EndpointsCreate_575075,
    schemes: {Scheme.Https})
type
  Call_EndpointsGet_575061 = ref object of OpenApiRestCall_574442
proc url_EndpointsGet_575063(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsGet_575062(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575064 = path.getOrDefault("resourceGroupName")
  valid_575064 = validateParameter(valid_575064, JString, required = true,
                                 default = nil)
  if valid_575064 != nil:
    section.add "resourceGroupName", valid_575064
  var valid_575065 = path.getOrDefault("subscriptionId")
  valid_575065 = validateParameter(valid_575065, JString, required = true,
                                 default = nil)
  if valid_575065 != nil:
    section.add "subscriptionId", valid_575065
  var valid_575066 = path.getOrDefault("profileName")
  valid_575066 = validateParameter(valid_575066, JString, required = true,
                                 default = nil)
  if valid_575066 != nil:
    section.add "profileName", valid_575066
  var valid_575067 = path.getOrDefault("endpointName")
  valid_575067 = validateParameter(valid_575067, JString, required = true,
                                 default = nil)
  if valid_575067 != nil:
    section.add "endpointName", valid_575067
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575068 = query.getOrDefault("api-version")
  valid_575068 = validateParameter(valid_575068, JString, required = true,
                                 default = nil)
  if valid_575068 != nil:
    section.add "api-version", valid_575068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575069: Call_EndpointsGet_575061; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575069.validator(path, query, header, formData, body)
  let scheme = call_575069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575069.url(scheme.get, call_575069.host, call_575069.base,
                         call_575069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575069, url, valid)

proc call*(call_575070: Call_EndpointsGet_575061; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          endpointName: string): Recallable =
  ## endpointsGet
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575071 = newJObject()
  var query_575072 = newJObject()
  add(path_575071, "resourceGroupName", newJString(resourceGroupName))
  add(query_575072, "api-version", newJString(apiVersion))
  add(path_575071, "subscriptionId", newJString(subscriptionId))
  add(path_575071, "profileName", newJString(profileName))
  add(path_575071, "endpointName", newJString(endpointName))
  result = call_575070.call(path_575071, query_575072, nil, nil, nil)

var endpointsGet* = Call_EndpointsGet_575061(name: "endpointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsGet_575062, base: "", url: url_EndpointsGet_575063,
    schemes: {Scheme.Https})
type
  Call_EndpointsUpdate_575099 = ref object of OpenApiRestCall_574442
proc url_EndpointsUpdate_575101(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsUpdate_575100(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575102 = path.getOrDefault("resourceGroupName")
  valid_575102 = validateParameter(valid_575102, JString, required = true,
                                 default = nil)
  if valid_575102 != nil:
    section.add "resourceGroupName", valid_575102
  var valid_575103 = path.getOrDefault("subscriptionId")
  valid_575103 = validateParameter(valid_575103, JString, required = true,
                                 default = nil)
  if valid_575103 != nil:
    section.add "subscriptionId", valid_575103
  var valid_575104 = path.getOrDefault("profileName")
  valid_575104 = validateParameter(valid_575104, JString, required = true,
                                 default = nil)
  if valid_575104 != nil:
    section.add "profileName", valid_575104
  var valid_575105 = path.getOrDefault("endpointName")
  valid_575105 = validateParameter(valid_575105, JString, required = true,
                                 default = nil)
  if valid_575105 != nil:
    section.add "endpointName", valid_575105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575106 = query.getOrDefault("api-version")
  valid_575106 = validateParameter(valid_575106, JString, required = true,
                                 default = nil)
  if valid_575106 != nil:
    section.add "api-version", valid_575106
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

proc call*(call_575108: Call_EndpointsUpdate_575099; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575108.validator(path, query, header, formData, body)
  let scheme = call_575108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575108.url(scheme.get, call_575108.host, call_575108.base,
                         call_575108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575108, url, valid)

proc call*(call_575109: Call_EndpointsUpdate_575099; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; endpointProperties: JsonNode;
          profileName: string; endpointName: string): Recallable =
  ## endpointsUpdate
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   endpointProperties: JObject (required)
  ##                     : Endpoint properties
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575110 = newJObject()
  var query_575111 = newJObject()
  var body_575112 = newJObject()
  add(path_575110, "resourceGroupName", newJString(resourceGroupName))
  add(query_575111, "api-version", newJString(apiVersion))
  add(path_575110, "subscriptionId", newJString(subscriptionId))
  if endpointProperties != nil:
    body_575112 = endpointProperties
  add(path_575110, "profileName", newJString(profileName))
  add(path_575110, "endpointName", newJString(endpointName))
  result = call_575109.call(path_575110, query_575111, nil, nil, body_575112)

var endpointsUpdate* = Call_EndpointsUpdate_575099(name: "endpointsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsUpdate_575100, base: "", url: url_EndpointsUpdate_575101,
    schemes: {Scheme.Https})
type
  Call_EndpointsDeleteIfExists_575087 = ref object of OpenApiRestCall_574442
proc url_EndpointsDeleteIfExists_575089(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsDeleteIfExists_575088(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575090 = path.getOrDefault("resourceGroupName")
  valid_575090 = validateParameter(valid_575090, JString, required = true,
                                 default = nil)
  if valid_575090 != nil:
    section.add "resourceGroupName", valid_575090
  var valid_575091 = path.getOrDefault("subscriptionId")
  valid_575091 = validateParameter(valid_575091, JString, required = true,
                                 default = nil)
  if valid_575091 != nil:
    section.add "subscriptionId", valid_575091
  var valid_575092 = path.getOrDefault("profileName")
  valid_575092 = validateParameter(valid_575092, JString, required = true,
                                 default = nil)
  if valid_575092 != nil:
    section.add "profileName", valid_575092
  var valid_575093 = path.getOrDefault("endpointName")
  valid_575093 = validateParameter(valid_575093, JString, required = true,
                                 default = nil)
  if valid_575093 != nil:
    section.add "endpointName", valid_575093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575094 = query.getOrDefault("api-version")
  valid_575094 = validateParameter(valid_575094, JString, required = true,
                                 default = nil)
  if valid_575094 != nil:
    section.add "api-version", valid_575094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575095: Call_EndpointsDeleteIfExists_575087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575095.validator(path, query, header, formData, body)
  let scheme = call_575095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575095.url(scheme.get, call_575095.host, call_575095.base,
                         call_575095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575095, url, valid)

proc call*(call_575096: Call_EndpointsDeleteIfExists_575087;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## endpointsDeleteIfExists
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575097 = newJObject()
  var query_575098 = newJObject()
  add(path_575097, "resourceGroupName", newJString(resourceGroupName))
  add(query_575098, "api-version", newJString(apiVersion))
  add(path_575097, "subscriptionId", newJString(subscriptionId))
  add(path_575097, "profileName", newJString(profileName))
  add(path_575097, "endpointName", newJString(endpointName))
  result = call_575096.call(path_575097, query_575098, nil, nil, nil)

var endpointsDeleteIfExists* = Call_EndpointsDeleteIfExists_575087(
    name: "endpointsDeleteIfExists", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsDeleteIfExists_575088, base: "",
    url: url_EndpointsDeleteIfExists_575089, schemes: {Scheme.Https})
type
  Call_CustomDomainsListByEndpoint_575113 = ref object of OpenApiRestCall_574442
proc url_CustomDomainsListByEndpoint_575115(protocol: Scheme; host: string;
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

proc validate_CustomDomainsListByEndpoint_575114(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575116 = path.getOrDefault("resourceGroupName")
  valid_575116 = validateParameter(valid_575116, JString, required = true,
                                 default = nil)
  if valid_575116 != nil:
    section.add "resourceGroupName", valid_575116
  var valid_575117 = path.getOrDefault("subscriptionId")
  valid_575117 = validateParameter(valid_575117, JString, required = true,
                                 default = nil)
  if valid_575117 != nil:
    section.add "subscriptionId", valid_575117
  var valid_575118 = path.getOrDefault("profileName")
  valid_575118 = validateParameter(valid_575118, JString, required = true,
                                 default = nil)
  if valid_575118 != nil:
    section.add "profileName", valid_575118
  var valid_575119 = path.getOrDefault("endpointName")
  valid_575119 = validateParameter(valid_575119, JString, required = true,
                                 default = nil)
  if valid_575119 != nil:
    section.add "endpointName", valid_575119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575120 = query.getOrDefault("api-version")
  valid_575120 = validateParameter(valid_575120, JString, required = true,
                                 default = nil)
  if valid_575120 != nil:
    section.add "api-version", valid_575120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575121: Call_CustomDomainsListByEndpoint_575113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575121.validator(path, query, header, formData, body)
  let scheme = call_575121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575121.url(scheme.get, call_575121.host, call_575121.base,
                         call_575121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575121, url, valid)

proc call*(call_575122: Call_CustomDomainsListByEndpoint_575113;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## customDomainsListByEndpoint
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575123 = newJObject()
  var query_575124 = newJObject()
  add(path_575123, "resourceGroupName", newJString(resourceGroupName))
  add(query_575124, "api-version", newJString(apiVersion))
  add(path_575123, "subscriptionId", newJString(subscriptionId))
  add(path_575123, "profileName", newJString(profileName))
  add(path_575123, "endpointName", newJString(endpointName))
  result = call_575122.call(path_575123, query_575124, nil, nil, nil)

var customDomainsListByEndpoint* = Call_CustomDomainsListByEndpoint_575113(
    name: "customDomainsListByEndpoint", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains",
    validator: validate_CustomDomainsListByEndpoint_575114, base: "",
    url: url_CustomDomainsListByEndpoint_575115, schemes: {Scheme.Https})
type
  Call_CustomDomainsCreate_575138 = ref object of OpenApiRestCall_574442
proc url_CustomDomainsCreate_575140(protocol: Scheme; host: string; base: string;
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

proc validate_CustomDomainsCreate_575139(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575141 = path.getOrDefault("resourceGroupName")
  valid_575141 = validateParameter(valid_575141, JString, required = true,
                                 default = nil)
  if valid_575141 != nil:
    section.add "resourceGroupName", valid_575141
  var valid_575142 = path.getOrDefault("subscriptionId")
  valid_575142 = validateParameter(valid_575142, JString, required = true,
                                 default = nil)
  if valid_575142 != nil:
    section.add "subscriptionId", valid_575142
  var valid_575143 = path.getOrDefault("customDomainName")
  valid_575143 = validateParameter(valid_575143, JString, required = true,
                                 default = nil)
  if valid_575143 != nil:
    section.add "customDomainName", valid_575143
  var valid_575144 = path.getOrDefault("profileName")
  valid_575144 = validateParameter(valid_575144, JString, required = true,
                                 default = nil)
  if valid_575144 != nil:
    section.add "profileName", valid_575144
  var valid_575145 = path.getOrDefault("endpointName")
  valid_575145 = validateParameter(valid_575145, JString, required = true,
                                 default = nil)
  if valid_575145 != nil:
    section.add "endpointName", valid_575145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575146 = query.getOrDefault("api-version")
  valid_575146 = validateParameter(valid_575146, JString, required = true,
                                 default = nil)
  if valid_575146 != nil:
    section.add "api-version", valid_575146
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

proc call*(call_575148: Call_CustomDomainsCreate_575138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575148.validator(path, query, header, formData, body)
  let scheme = call_575148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575148.url(scheme.get, call_575148.host, call_575148.base,
                         call_575148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575148, url, valid)

proc call*(call_575149: Call_CustomDomainsCreate_575138; resourceGroupName: string;
          apiVersion: string; customDomainProperties: JsonNode;
          subscriptionId: string; customDomainName: string; profileName: string;
          endpointName: string): Recallable =
  ## customDomainsCreate
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain properties required for creation.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575150 = newJObject()
  var query_575151 = newJObject()
  var body_575152 = newJObject()
  add(path_575150, "resourceGroupName", newJString(resourceGroupName))
  add(query_575151, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_575152 = customDomainProperties
  add(path_575150, "subscriptionId", newJString(subscriptionId))
  add(path_575150, "customDomainName", newJString(customDomainName))
  add(path_575150, "profileName", newJString(profileName))
  add(path_575150, "endpointName", newJString(endpointName))
  result = call_575149.call(path_575150, query_575151, nil, nil, body_575152)

var customDomainsCreate* = Call_CustomDomainsCreate_575138(
    name: "customDomainsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsCreate_575139, base: "",
    url: url_CustomDomainsCreate_575140, schemes: {Scheme.Https})
type
  Call_CustomDomainsGet_575125 = ref object of OpenApiRestCall_574442
proc url_CustomDomainsGet_575127(protocol: Scheme; host: string; base: string;
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

proc validate_CustomDomainsGet_575126(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575128 = path.getOrDefault("resourceGroupName")
  valid_575128 = validateParameter(valid_575128, JString, required = true,
                                 default = nil)
  if valid_575128 != nil:
    section.add "resourceGroupName", valid_575128
  var valid_575129 = path.getOrDefault("subscriptionId")
  valid_575129 = validateParameter(valid_575129, JString, required = true,
                                 default = nil)
  if valid_575129 != nil:
    section.add "subscriptionId", valid_575129
  var valid_575130 = path.getOrDefault("customDomainName")
  valid_575130 = validateParameter(valid_575130, JString, required = true,
                                 default = nil)
  if valid_575130 != nil:
    section.add "customDomainName", valid_575130
  var valid_575131 = path.getOrDefault("profileName")
  valid_575131 = validateParameter(valid_575131, JString, required = true,
                                 default = nil)
  if valid_575131 != nil:
    section.add "profileName", valid_575131
  var valid_575132 = path.getOrDefault("endpointName")
  valid_575132 = validateParameter(valid_575132, JString, required = true,
                                 default = nil)
  if valid_575132 != nil:
    section.add "endpointName", valid_575132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
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
  if body != nil:
    result.add "body", body

proc call*(call_575134: Call_CustomDomainsGet_575125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575134.validator(path, query, header, formData, body)
  let scheme = call_575134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575134.url(scheme.get, call_575134.host, call_575134.base,
                         call_575134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575134, url, valid)

proc call*(call_575135: Call_CustomDomainsGet_575125; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; customDomainName: string;
          profileName: string; endpointName: string): Recallable =
  ## customDomainsGet
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575136 = newJObject()
  var query_575137 = newJObject()
  add(path_575136, "resourceGroupName", newJString(resourceGroupName))
  add(query_575137, "api-version", newJString(apiVersion))
  add(path_575136, "subscriptionId", newJString(subscriptionId))
  add(path_575136, "customDomainName", newJString(customDomainName))
  add(path_575136, "profileName", newJString(profileName))
  add(path_575136, "endpointName", newJString(endpointName))
  result = call_575135.call(path_575136, query_575137, nil, nil, nil)

var customDomainsGet* = Call_CustomDomainsGet_575125(name: "customDomainsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsGet_575126, base: "",
    url: url_CustomDomainsGet_575127, schemes: {Scheme.Https})
type
  Call_CustomDomainsUpdate_575166 = ref object of OpenApiRestCall_574442
proc url_CustomDomainsUpdate_575168(protocol: Scheme; host: string; base: string;
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

proc validate_CustomDomainsUpdate_575167(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575169 = path.getOrDefault("resourceGroupName")
  valid_575169 = validateParameter(valid_575169, JString, required = true,
                                 default = nil)
  if valid_575169 != nil:
    section.add "resourceGroupName", valid_575169
  var valid_575170 = path.getOrDefault("subscriptionId")
  valid_575170 = validateParameter(valid_575170, JString, required = true,
                                 default = nil)
  if valid_575170 != nil:
    section.add "subscriptionId", valid_575170
  var valid_575171 = path.getOrDefault("customDomainName")
  valid_575171 = validateParameter(valid_575171, JString, required = true,
                                 default = nil)
  if valid_575171 != nil:
    section.add "customDomainName", valid_575171
  var valid_575172 = path.getOrDefault("profileName")
  valid_575172 = validateParameter(valid_575172, JString, required = true,
                                 default = nil)
  if valid_575172 != nil:
    section.add "profileName", valid_575172
  var valid_575173 = path.getOrDefault("endpointName")
  valid_575173 = validateParameter(valid_575173, JString, required = true,
                                 default = nil)
  if valid_575173 != nil:
    section.add "endpointName", valid_575173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
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
  ## parameters in `body` object:
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain properties to update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575176: Call_CustomDomainsUpdate_575166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575176.validator(path, query, header, formData, body)
  let scheme = call_575176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575176.url(scheme.get, call_575176.host, call_575176.base,
                         call_575176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575176, url, valid)

proc call*(call_575177: Call_CustomDomainsUpdate_575166; resourceGroupName: string;
          apiVersion: string; customDomainProperties: JsonNode;
          subscriptionId: string; customDomainName: string; profileName: string;
          endpointName: string): Recallable =
  ## customDomainsUpdate
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain properties to update.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575178 = newJObject()
  var query_575179 = newJObject()
  var body_575180 = newJObject()
  add(path_575178, "resourceGroupName", newJString(resourceGroupName))
  add(query_575179, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_575180 = customDomainProperties
  add(path_575178, "subscriptionId", newJString(subscriptionId))
  add(path_575178, "customDomainName", newJString(customDomainName))
  add(path_575178, "profileName", newJString(profileName))
  add(path_575178, "endpointName", newJString(endpointName))
  result = call_575177.call(path_575178, query_575179, nil, nil, body_575180)

var customDomainsUpdate* = Call_CustomDomainsUpdate_575166(
    name: "customDomainsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsUpdate_575167, base: "",
    url: url_CustomDomainsUpdate_575168, schemes: {Scheme.Https})
type
  Call_CustomDomainsDeleteIfExists_575153 = ref object of OpenApiRestCall_574442
proc url_CustomDomainsDeleteIfExists_575155(protocol: Scheme; host: string;
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

proc validate_CustomDomainsDeleteIfExists_575154(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575156 = path.getOrDefault("resourceGroupName")
  valid_575156 = validateParameter(valid_575156, JString, required = true,
                                 default = nil)
  if valid_575156 != nil:
    section.add "resourceGroupName", valid_575156
  var valid_575157 = path.getOrDefault("subscriptionId")
  valid_575157 = validateParameter(valid_575157, JString, required = true,
                                 default = nil)
  if valid_575157 != nil:
    section.add "subscriptionId", valid_575157
  var valid_575158 = path.getOrDefault("customDomainName")
  valid_575158 = validateParameter(valid_575158, JString, required = true,
                                 default = nil)
  if valid_575158 != nil:
    section.add "customDomainName", valid_575158
  var valid_575159 = path.getOrDefault("profileName")
  valid_575159 = validateParameter(valid_575159, JString, required = true,
                                 default = nil)
  if valid_575159 != nil:
    section.add "profileName", valid_575159
  var valid_575160 = path.getOrDefault("endpointName")
  valid_575160 = validateParameter(valid_575160, JString, required = true,
                                 default = nil)
  if valid_575160 != nil:
    section.add "endpointName", valid_575160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
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

proc call*(call_575162: Call_CustomDomainsDeleteIfExists_575153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575162.validator(path, query, header, formData, body)
  let scheme = call_575162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575162.url(scheme.get, call_575162.host, call_575162.base,
                         call_575162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575162, url, valid)

proc call*(call_575163: Call_CustomDomainsDeleteIfExists_575153;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          customDomainName: string; profileName: string; endpointName: string): Recallable =
  ## customDomainsDeleteIfExists
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575164 = newJObject()
  var query_575165 = newJObject()
  add(path_575164, "resourceGroupName", newJString(resourceGroupName))
  add(query_575165, "api-version", newJString(apiVersion))
  add(path_575164, "subscriptionId", newJString(subscriptionId))
  add(path_575164, "customDomainName", newJString(customDomainName))
  add(path_575164, "profileName", newJString(profileName))
  add(path_575164, "endpointName", newJString(endpointName))
  result = call_575163.call(path_575164, query_575165, nil, nil, nil)

var customDomainsDeleteIfExists* = Call_CustomDomainsDeleteIfExists_575153(
    name: "customDomainsDeleteIfExists", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsDeleteIfExists_575154, base: "",
    url: url_CustomDomainsDeleteIfExists_575155, schemes: {Scheme.Https})
type
  Call_EndpointsLoadContent_575181 = ref object of OpenApiRestCall_574442
proc url_EndpointsLoadContent_575183(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsLoadContent_575182(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575184 = path.getOrDefault("resourceGroupName")
  valid_575184 = validateParameter(valid_575184, JString, required = true,
                                 default = nil)
  if valid_575184 != nil:
    section.add "resourceGroupName", valid_575184
  var valid_575185 = path.getOrDefault("subscriptionId")
  valid_575185 = validateParameter(valid_575185, JString, required = true,
                                 default = nil)
  if valid_575185 != nil:
    section.add "subscriptionId", valid_575185
  var valid_575186 = path.getOrDefault("profileName")
  valid_575186 = validateParameter(valid_575186, JString, required = true,
                                 default = nil)
  if valid_575186 != nil:
    section.add "profileName", valid_575186
  var valid_575187 = path.getOrDefault("endpointName")
  valid_575187 = validateParameter(valid_575187, JString, required = true,
                                 default = nil)
  if valid_575187 != nil:
    section.add "endpointName", valid_575187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575188 = query.getOrDefault("api-version")
  valid_575188 = validateParameter(valid_575188, JString, required = true,
                                 default = nil)
  if valid_575188 != nil:
    section.add "api-version", valid_575188
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

proc call*(call_575190: Call_EndpointsLoadContent_575181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575190.validator(path, query, header, formData, body)
  let scheme = call_575190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575190.url(scheme.get, call_575190.host, call_575190.base,
                         call_575190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575190, url, valid)

proc call*(call_575191: Call_EndpointsLoadContent_575181;
          resourceGroupName: string; contentFilePaths: JsonNode; apiVersion: string;
          subscriptionId: string; profileName: string; endpointName: string): Recallable =
  ## endpointsLoadContent
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be loaded. Path should describe a file.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575192 = newJObject()
  var query_575193 = newJObject()
  var body_575194 = newJObject()
  add(path_575192, "resourceGroupName", newJString(resourceGroupName))
  if contentFilePaths != nil:
    body_575194 = contentFilePaths
  add(query_575193, "api-version", newJString(apiVersion))
  add(path_575192, "subscriptionId", newJString(subscriptionId))
  add(path_575192, "profileName", newJString(profileName))
  add(path_575192, "endpointName", newJString(endpointName))
  result = call_575191.call(path_575192, query_575193, nil, nil, body_575194)

var endpointsLoadContent* = Call_EndpointsLoadContent_575181(
    name: "endpointsLoadContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/load",
    validator: validate_EndpointsLoadContent_575182, base: "",
    url: url_EndpointsLoadContent_575183, schemes: {Scheme.Https})
type
  Call_OriginsListByEndpoint_575195 = ref object of OpenApiRestCall_574442
proc url_OriginsListByEndpoint_575197(protocol: Scheme; host: string; base: string;
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

proc validate_OriginsListByEndpoint_575196(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575198 = path.getOrDefault("resourceGroupName")
  valid_575198 = validateParameter(valid_575198, JString, required = true,
                                 default = nil)
  if valid_575198 != nil:
    section.add "resourceGroupName", valid_575198
  var valid_575199 = path.getOrDefault("subscriptionId")
  valid_575199 = validateParameter(valid_575199, JString, required = true,
                                 default = nil)
  if valid_575199 != nil:
    section.add "subscriptionId", valid_575199
  var valid_575200 = path.getOrDefault("profileName")
  valid_575200 = validateParameter(valid_575200, JString, required = true,
                                 default = nil)
  if valid_575200 != nil:
    section.add "profileName", valid_575200
  var valid_575201 = path.getOrDefault("endpointName")
  valid_575201 = validateParameter(valid_575201, JString, required = true,
                                 default = nil)
  if valid_575201 != nil:
    section.add "endpointName", valid_575201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575202 = query.getOrDefault("api-version")
  valid_575202 = validateParameter(valid_575202, JString, required = true,
                                 default = nil)
  if valid_575202 != nil:
    section.add "api-version", valid_575202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575203: Call_OriginsListByEndpoint_575195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575203.validator(path, query, header, formData, body)
  let scheme = call_575203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575203.url(scheme.get, call_575203.host, call_575203.base,
                         call_575203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575203, url, valid)

proc call*(call_575204: Call_OriginsListByEndpoint_575195;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## originsListByEndpoint
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575205 = newJObject()
  var query_575206 = newJObject()
  add(path_575205, "resourceGroupName", newJString(resourceGroupName))
  add(query_575206, "api-version", newJString(apiVersion))
  add(path_575205, "subscriptionId", newJString(subscriptionId))
  add(path_575205, "profileName", newJString(profileName))
  add(path_575205, "endpointName", newJString(endpointName))
  result = call_575204.call(path_575205, query_575206, nil, nil, nil)

var originsListByEndpoint* = Call_OriginsListByEndpoint_575195(
    name: "originsListByEndpoint", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins",
    validator: validate_OriginsListByEndpoint_575196, base: "",
    url: url_OriginsListByEndpoint_575197, schemes: {Scheme.Https})
type
  Call_OriginsCreate_575220 = ref object of OpenApiRestCall_574442
proc url_OriginsCreate_575222(protocol: Scheme; host: string; base: string;
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

proc validate_OriginsCreate_575221(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   originName: JString (required)
  ##             : Name of the origin, an arbitrary value but it needs to be unique under endpoint
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575223 = path.getOrDefault("resourceGroupName")
  valid_575223 = validateParameter(valid_575223, JString, required = true,
                                 default = nil)
  if valid_575223 != nil:
    section.add "resourceGroupName", valid_575223
  var valid_575224 = path.getOrDefault("originName")
  valid_575224 = validateParameter(valid_575224, JString, required = true,
                                 default = nil)
  if valid_575224 != nil:
    section.add "originName", valid_575224
  var valid_575225 = path.getOrDefault("subscriptionId")
  valid_575225 = validateParameter(valid_575225, JString, required = true,
                                 default = nil)
  if valid_575225 != nil:
    section.add "subscriptionId", valid_575225
  var valid_575226 = path.getOrDefault("profileName")
  valid_575226 = validateParameter(valid_575226, JString, required = true,
                                 default = nil)
  if valid_575226 != nil:
    section.add "profileName", valid_575226
  var valid_575227 = path.getOrDefault("endpointName")
  valid_575227 = validateParameter(valid_575227, JString, required = true,
                                 default = nil)
  if valid_575227 != nil:
    section.add "endpointName", valid_575227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575228 = query.getOrDefault("api-version")
  valid_575228 = validateParameter(valid_575228, JString, required = true,
                                 default = nil)
  if valid_575228 != nil:
    section.add "api-version", valid_575228
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

proc call*(call_575230: Call_OriginsCreate_575220; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575230.validator(path, query, header, formData, body)
  let scheme = call_575230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575230.url(scheme.get, call_575230.host, call_575230.base,
                         call_575230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575230, url, valid)

proc call*(call_575231: Call_OriginsCreate_575220; resourceGroupName: string;
          apiVersion: string; originName: string; subscriptionId: string;
          originProperties: JsonNode; profileName: string; endpointName: string): Recallable =
  ## originsCreate
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   originName: string (required)
  ##             : Name of the origin, an arbitrary value but it needs to be unique under endpoint
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   originProperties: JObject (required)
  ##                   : Origin properties
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575232 = newJObject()
  var query_575233 = newJObject()
  var body_575234 = newJObject()
  add(path_575232, "resourceGroupName", newJString(resourceGroupName))
  add(query_575233, "api-version", newJString(apiVersion))
  add(path_575232, "originName", newJString(originName))
  add(path_575232, "subscriptionId", newJString(subscriptionId))
  if originProperties != nil:
    body_575234 = originProperties
  add(path_575232, "profileName", newJString(profileName))
  add(path_575232, "endpointName", newJString(endpointName))
  result = call_575231.call(path_575232, query_575233, nil, nil, body_575234)

var originsCreate* = Call_OriginsCreate_575220(name: "originsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
    validator: validate_OriginsCreate_575221, base: "", url: url_OriginsCreate_575222,
    schemes: {Scheme.Https})
type
  Call_OriginsGet_575207 = ref object of OpenApiRestCall_574442
proc url_OriginsGet_575209(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_OriginsGet_575208(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   originName: JString (required)
  ##             : Name of the origin, an arbitrary value but it needs to be unique under endpoint
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575210 = path.getOrDefault("resourceGroupName")
  valid_575210 = validateParameter(valid_575210, JString, required = true,
                                 default = nil)
  if valid_575210 != nil:
    section.add "resourceGroupName", valid_575210
  var valid_575211 = path.getOrDefault("originName")
  valid_575211 = validateParameter(valid_575211, JString, required = true,
                                 default = nil)
  if valid_575211 != nil:
    section.add "originName", valid_575211
  var valid_575212 = path.getOrDefault("subscriptionId")
  valid_575212 = validateParameter(valid_575212, JString, required = true,
                                 default = nil)
  if valid_575212 != nil:
    section.add "subscriptionId", valid_575212
  var valid_575213 = path.getOrDefault("profileName")
  valid_575213 = validateParameter(valid_575213, JString, required = true,
                                 default = nil)
  if valid_575213 != nil:
    section.add "profileName", valid_575213
  var valid_575214 = path.getOrDefault("endpointName")
  valid_575214 = validateParameter(valid_575214, JString, required = true,
                                 default = nil)
  if valid_575214 != nil:
    section.add "endpointName", valid_575214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575215 = query.getOrDefault("api-version")
  valid_575215 = validateParameter(valid_575215, JString, required = true,
                                 default = nil)
  if valid_575215 != nil:
    section.add "api-version", valid_575215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575216: Call_OriginsGet_575207; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575216.validator(path, query, header, formData, body)
  let scheme = call_575216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575216.url(scheme.get, call_575216.host, call_575216.base,
                         call_575216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575216, url, valid)

proc call*(call_575217: Call_OriginsGet_575207; resourceGroupName: string;
          apiVersion: string; originName: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## originsGet
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   originName: string (required)
  ##             : Name of the origin, an arbitrary value but it needs to be unique under endpoint
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575218 = newJObject()
  var query_575219 = newJObject()
  add(path_575218, "resourceGroupName", newJString(resourceGroupName))
  add(query_575219, "api-version", newJString(apiVersion))
  add(path_575218, "originName", newJString(originName))
  add(path_575218, "subscriptionId", newJString(subscriptionId))
  add(path_575218, "profileName", newJString(profileName))
  add(path_575218, "endpointName", newJString(endpointName))
  result = call_575217.call(path_575218, query_575219, nil, nil, nil)

var originsGet* = Call_OriginsGet_575207(name: "originsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
                                      validator: validate_OriginsGet_575208,
                                      base: "", url: url_OriginsGet_575209,
                                      schemes: {Scheme.Https})
type
  Call_OriginsUpdate_575248 = ref object of OpenApiRestCall_574442
proc url_OriginsUpdate_575250(protocol: Scheme; host: string; base: string;
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

proc validate_OriginsUpdate_575249(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   originName: JString (required)
  ##             : Name of the origin. Must be unique within endpoint.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575251 = path.getOrDefault("resourceGroupName")
  valid_575251 = validateParameter(valid_575251, JString, required = true,
                                 default = nil)
  if valid_575251 != nil:
    section.add "resourceGroupName", valid_575251
  var valid_575252 = path.getOrDefault("originName")
  valid_575252 = validateParameter(valid_575252, JString, required = true,
                                 default = nil)
  if valid_575252 != nil:
    section.add "originName", valid_575252
  var valid_575253 = path.getOrDefault("subscriptionId")
  valid_575253 = validateParameter(valid_575253, JString, required = true,
                                 default = nil)
  if valid_575253 != nil:
    section.add "subscriptionId", valid_575253
  var valid_575254 = path.getOrDefault("profileName")
  valid_575254 = validateParameter(valid_575254, JString, required = true,
                                 default = nil)
  if valid_575254 != nil:
    section.add "profileName", valid_575254
  var valid_575255 = path.getOrDefault("endpointName")
  valid_575255 = validateParameter(valid_575255, JString, required = true,
                                 default = nil)
  if valid_575255 != nil:
    section.add "endpointName", valid_575255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575256 = query.getOrDefault("api-version")
  valid_575256 = validateParameter(valid_575256, JString, required = true,
                                 default = nil)
  if valid_575256 != nil:
    section.add "api-version", valid_575256
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

proc call*(call_575258: Call_OriginsUpdate_575248; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575258.validator(path, query, header, formData, body)
  let scheme = call_575258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575258.url(scheme.get, call_575258.host, call_575258.base,
                         call_575258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575258, url, valid)

proc call*(call_575259: Call_OriginsUpdate_575248; resourceGroupName: string;
          apiVersion: string; originName: string; subscriptionId: string;
          originProperties: JsonNode; profileName: string; endpointName: string): Recallable =
  ## originsUpdate
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   originName: string (required)
  ##             : Name of the origin. Must be unique within endpoint.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   originProperties: JObject (required)
  ##                   : Origin properties
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575260 = newJObject()
  var query_575261 = newJObject()
  var body_575262 = newJObject()
  add(path_575260, "resourceGroupName", newJString(resourceGroupName))
  add(query_575261, "api-version", newJString(apiVersion))
  add(path_575260, "originName", newJString(originName))
  add(path_575260, "subscriptionId", newJString(subscriptionId))
  if originProperties != nil:
    body_575262 = originProperties
  add(path_575260, "profileName", newJString(profileName))
  add(path_575260, "endpointName", newJString(endpointName))
  result = call_575259.call(path_575260, query_575261, nil, nil, body_575262)

var originsUpdate* = Call_OriginsUpdate_575248(name: "originsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
    validator: validate_OriginsUpdate_575249, base: "", url: url_OriginsUpdate_575250,
    schemes: {Scheme.Https})
type
  Call_OriginsDeleteIfExists_575235 = ref object of OpenApiRestCall_574442
proc url_OriginsDeleteIfExists_575237(protocol: Scheme; host: string; base: string;
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

proc validate_OriginsDeleteIfExists_575236(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   originName: JString (required)
  ##             : Name of the origin. Must be unique within endpoint.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575238 = path.getOrDefault("resourceGroupName")
  valid_575238 = validateParameter(valid_575238, JString, required = true,
                                 default = nil)
  if valid_575238 != nil:
    section.add "resourceGroupName", valid_575238
  var valid_575239 = path.getOrDefault("originName")
  valid_575239 = validateParameter(valid_575239, JString, required = true,
                                 default = nil)
  if valid_575239 != nil:
    section.add "originName", valid_575239
  var valid_575240 = path.getOrDefault("subscriptionId")
  valid_575240 = validateParameter(valid_575240, JString, required = true,
                                 default = nil)
  if valid_575240 != nil:
    section.add "subscriptionId", valid_575240
  var valid_575241 = path.getOrDefault("profileName")
  valid_575241 = validateParameter(valid_575241, JString, required = true,
                                 default = nil)
  if valid_575241 != nil:
    section.add "profileName", valid_575241
  var valid_575242 = path.getOrDefault("endpointName")
  valid_575242 = validateParameter(valid_575242, JString, required = true,
                                 default = nil)
  if valid_575242 != nil:
    section.add "endpointName", valid_575242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575243 = query.getOrDefault("api-version")
  valid_575243 = validateParameter(valid_575243, JString, required = true,
                                 default = nil)
  if valid_575243 != nil:
    section.add "api-version", valid_575243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575244: Call_OriginsDeleteIfExists_575235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575244.validator(path, query, header, formData, body)
  let scheme = call_575244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575244.url(scheme.get, call_575244.host, call_575244.base,
                         call_575244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575244, url, valid)

proc call*(call_575245: Call_OriginsDeleteIfExists_575235;
          resourceGroupName: string; apiVersion: string; originName: string;
          subscriptionId: string; profileName: string; endpointName: string): Recallable =
  ## originsDeleteIfExists
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   originName: string (required)
  ##             : Name of the origin. Must be unique within endpoint.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575246 = newJObject()
  var query_575247 = newJObject()
  add(path_575246, "resourceGroupName", newJString(resourceGroupName))
  add(query_575247, "api-version", newJString(apiVersion))
  add(path_575246, "originName", newJString(originName))
  add(path_575246, "subscriptionId", newJString(subscriptionId))
  add(path_575246, "profileName", newJString(profileName))
  add(path_575246, "endpointName", newJString(endpointName))
  result = call_575245.call(path_575246, query_575247, nil, nil, nil)

var originsDeleteIfExists* = Call_OriginsDeleteIfExists_575235(
    name: "originsDeleteIfExists", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
    validator: validate_OriginsDeleteIfExists_575236, base: "",
    url: url_OriginsDeleteIfExists_575237, schemes: {Scheme.Https})
type
  Call_EndpointsPurgeContent_575263 = ref object of OpenApiRestCall_574442
proc url_EndpointsPurgeContent_575265(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsPurgeContent_575264(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575266 = path.getOrDefault("resourceGroupName")
  valid_575266 = validateParameter(valid_575266, JString, required = true,
                                 default = nil)
  if valid_575266 != nil:
    section.add "resourceGroupName", valid_575266
  var valid_575267 = path.getOrDefault("subscriptionId")
  valid_575267 = validateParameter(valid_575267, JString, required = true,
                                 default = nil)
  if valid_575267 != nil:
    section.add "subscriptionId", valid_575267
  var valid_575268 = path.getOrDefault("profileName")
  valid_575268 = validateParameter(valid_575268, JString, required = true,
                                 default = nil)
  if valid_575268 != nil:
    section.add "profileName", valid_575268
  var valid_575269 = path.getOrDefault("endpointName")
  valid_575269 = validateParameter(valid_575269, JString, required = true,
                                 default = nil)
  if valid_575269 != nil:
    section.add "endpointName", valid_575269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575270 = query.getOrDefault("api-version")
  valid_575270 = validateParameter(valid_575270, JString, required = true,
                                 default = nil)
  if valid_575270 != nil:
    section.add "api-version", valid_575270
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

proc call*(call_575272: Call_EndpointsPurgeContent_575263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575272.validator(path, query, header, formData, body)
  let scheme = call_575272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575272.url(scheme.get, call_575272.host, call_575272.base,
                         call_575272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575272, url, valid)

proc call*(call_575273: Call_EndpointsPurgeContent_575263;
          resourceGroupName: string; contentFilePaths: JsonNode; apiVersion: string;
          subscriptionId: string; profileName: string; endpointName: string): Recallable =
  ## endpointsPurgeContent
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be purged. Path can describe a file or directory.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575274 = newJObject()
  var query_575275 = newJObject()
  var body_575276 = newJObject()
  add(path_575274, "resourceGroupName", newJString(resourceGroupName))
  if contentFilePaths != nil:
    body_575276 = contentFilePaths
  add(query_575275, "api-version", newJString(apiVersion))
  add(path_575274, "subscriptionId", newJString(subscriptionId))
  add(path_575274, "profileName", newJString(profileName))
  add(path_575274, "endpointName", newJString(endpointName))
  result = call_575273.call(path_575274, query_575275, nil, nil, body_575276)

var endpointsPurgeContent* = Call_EndpointsPurgeContent_575263(
    name: "endpointsPurgeContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/purge",
    validator: validate_EndpointsPurgeContent_575264, base: "",
    url: url_EndpointsPurgeContent_575265, schemes: {Scheme.Https})
type
  Call_EndpointsStart_575277 = ref object of OpenApiRestCall_574442
proc url_EndpointsStart_575279(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsStart_575278(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575280 = path.getOrDefault("resourceGroupName")
  valid_575280 = validateParameter(valid_575280, JString, required = true,
                                 default = nil)
  if valid_575280 != nil:
    section.add "resourceGroupName", valid_575280
  var valid_575281 = path.getOrDefault("subscriptionId")
  valid_575281 = validateParameter(valid_575281, JString, required = true,
                                 default = nil)
  if valid_575281 != nil:
    section.add "subscriptionId", valid_575281
  var valid_575282 = path.getOrDefault("profileName")
  valid_575282 = validateParameter(valid_575282, JString, required = true,
                                 default = nil)
  if valid_575282 != nil:
    section.add "profileName", valid_575282
  var valid_575283 = path.getOrDefault("endpointName")
  valid_575283 = validateParameter(valid_575283, JString, required = true,
                                 default = nil)
  if valid_575283 != nil:
    section.add "endpointName", valid_575283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575284 = query.getOrDefault("api-version")
  valid_575284 = validateParameter(valid_575284, JString, required = true,
                                 default = nil)
  if valid_575284 != nil:
    section.add "api-version", valid_575284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575285: Call_EndpointsStart_575277; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575285.validator(path, query, header, formData, body)
  let scheme = call_575285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575285.url(scheme.get, call_575285.host, call_575285.base,
                         call_575285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575285, url, valid)

proc call*(call_575286: Call_EndpointsStart_575277; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          endpointName: string): Recallable =
  ## endpointsStart
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575287 = newJObject()
  var query_575288 = newJObject()
  add(path_575287, "resourceGroupName", newJString(resourceGroupName))
  add(query_575288, "api-version", newJString(apiVersion))
  add(path_575287, "subscriptionId", newJString(subscriptionId))
  add(path_575287, "profileName", newJString(profileName))
  add(path_575287, "endpointName", newJString(endpointName))
  result = call_575286.call(path_575287, query_575288, nil, nil, nil)

var endpointsStart* = Call_EndpointsStart_575277(name: "endpointsStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/start",
    validator: validate_EndpointsStart_575278, base: "", url: url_EndpointsStart_575279,
    schemes: {Scheme.Https})
type
  Call_EndpointsStop_575289 = ref object of OpenApiRestCall_574442
proc url_EndpointsStop_575291(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsStop_575290(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575292 = path.getOrDefault("resourceGroupName")
  valid_575292 = validateParameter(valid_575292, JString, required = true,
                                 default = nil)
  if valid_575292 != nil:
    section.add "resourceGroupName", valid_575292
  var valid_575293 = path.getOrDefault("subscriptionId")
  valid_575293 = validateParameter(valid_575293, JString, required = true,
                                 default = nil)
  if valid_575293 != nil:
    section.add "subscriptionId", valid_575293
  var valid_575294 = path.getOrDefault("profileName")
  valid_575294 = validateParameter(valid_575294, JString, required = true,
                                 default = nil)
  if valid_575294 != nil:
    section.add "profileName", valid_575294
  var valid_575295 = path.getOrDefault("endpointName")
  valid_575295 = validateParameter(valid_575295, JString, required = true,
                                 default = nil)
  if valid_575295 != nil:
    section.add "endpointName", valid_575295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575296 = query.getOrDefault("api-version")
  valid_575296 = validateParameter(valid_575296, JString, required = true,
                                 default = nil)
  if valid_575296 != nil:
    section.add "api-version", valid_575296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575297: Call_EndpointsStop_575289; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575297.validator(path, query, header, formData, body)
  let scheme = call_575297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575297.url(scheme.get, call_575297.host, call_575297.base,
                         call_575297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575297, url, valid)

proc call*(call_575298: Call_EndpointsStop_575289; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          endpointName: string): Recallable =
  ## endpointsStop
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575299 = newJObject()
  var query_575300 = newJObject()
  add(path_575299, "resourceGroupName", newJString(resourceGroupName))
  add(query_575300, "api-version", newJString(apiVersion))
  add(path_575299, "subscriptionId", newJString(subscriptionId))
  add(path_575299, "profileName", newJString(profileName))
  add(path_575299, "endpointName", newJString(endpointName))
  result = call_575298.call(path_575299, query_575300, nil, nil, nil)

var endpointsStop* = Call_EndpointsStop_575289(name: "endpointsStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/stop",
    validator: validate_EndpointsStop_575290, base: "", url: url_EndpointsStop_575291,
    schemes: {Scheme.Https})
type
  Call_EndpointsValidateCustomDomain_575301 = ref object of OpenApiRestCall_574442
proc url_EndpointsValidateCustomDomain_575303(protocol: Scheme; host: string;
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

proc validate_EndpointsValidateCustomDomain_575302(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint within the CDN profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575304 = path.getOrDefault("resourceGroupName")
  valid_575304 = validateParameter(valid_575304, JString, required = true,
                                 default = nil)
  if valid_575304 != nil:
    section.add "resourceGroupName", valid_575304
  var valid_575305 = path.getOrDefault("subscriptionId")
  valid_575305 = validateParameter(valid_575305, JString, required = true,
                                 default = nil)
  if valid_575305 != nil:
    section.add "subscriptionId", valid_575305
  var valid_575306 = path.getOrDefault("profileName")
  valid_575306 = validateParameter(valid_575306, JString, required = true,
                                 default = nil)
  if valid_575306 != nil:
    section.add "profileName", valid_575306
  var valid_575307 = path.getOrDefault("endpointName")
  valid_575307 = validateParameter(valid_575307, JString, required = true,
                                 default = nil)
  if valid_575307 != nil:
    section.add "endpointName", valid_575307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575308 = query.getOrDefault("api-version")
  valid_575308 = validateParameter(valid_575308, JString, required = true,
                                 default = nil)
  if valid_575308 != nil:
    section.add "api-version", valid_575308
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

proc call*(call_575310: Call_EndpointsValidateCustomDomain_575301; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575310.validator(path, query, header, formData, body)
  let scheme = call_575310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575310.url(scheme.get, call_575310.host, call_575310.base,
                         call_575310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575310, url, valid)

proc call*(call_575311: Call_EndpointsValidateCustomDomain_575301;
          resourceGroupName: string; apiVersion: string;
          customDomainProperties: JsonNode; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## endpointsValidateCustomDomain
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain to validate.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint within the CDN profile.
  var path_575312 = newJObject()
  var query_575313 = newJObject()
  var body_575314 = newJObject()
  add(path_575312, "resourceGroupName", newJString(resourceGroupName))
  add(query_575313, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_575314 = customDomainProperties
  add(path_575312, "subscriptionId", newJString(subscriptionId))
  add(path_575312, "profileName", newJString(profileName))
  add(path_575312, "endpointName", newJString(endpointName))
  result = call_575311.call(path_575312, query_575313, nil, nil, body_575314)

var endpointsValidateCustomDomain* = Call_EndpointsValidateCustomDomain_575301(
    name: "endpointsValidateCustomDomain", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/validateCustomDomain",
    validator: validate_EndpointsValidateCustomDomain_575302, base: "",
    url: url_EndpointsValidateCustomDomain_575303, schemes: {Scheme.Https})
type
  Call_ProfilesGenerateSsoUri_575315 = ref object of OpenApiRestCall_574442
proc url_ProfilesGenerateSsoUri_575317(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesGenerateSsoUri_575316(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575318 = path.getOrDefault("resourceGroupName")
  valid_575318 = validateParameter(valid_575318, JString, required = true,
                                 default = nil)
  if valid_575318 != nil:
    section.add "resourceGroupName", valid_575318
  var valid_575319 = path.getOrDefault("subscriptionId")
  valid_575319 = validateParameter(valid_575319, JString, required = true,
                                 default = nil)
  if valid_575319 != nil:
    section.add "subscriptionId", valid_575319
  var valid_575320 = path.getOrDefault("profileName")
  valid_575320 = validateParameter(valid_575320, JString, required = true,
                                 default = nil)
  if valid_575320 != nil:
    section.add "profileName", valid_575320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575321 = query.getOrDefault("api-version")
  valid_575321 = validateParameter(valid_575321, JString, required = true,
                                 default = nil)
  if valid_575321 != nil:
    section.add "api-version", valid_575321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575322: Call_ProfilesGenerateSsoUri_575315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575322.validator(path, query, header, formData, body)
  let scheme = call_575322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575322.url(scheme.get, call_575322.host, call_575322.base,
                         call_575322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575322, url, valid)

proc call*(call_575323: Call_ProfilesGenerateSsoUri_575315;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string): Recallable =
  ## profilesGenerateSsoUri
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile within the resource group.
  var path_575324 = newJObject()
  var query_575325 = newJObject()
  add(path_575324, "resourceGroupName", newJString(resourceGroupName))
  add(query_575325, "api-version", newJString(apiVersion))
  add(path_575324, "subscriptionId", newJString(subscriptionId))
  add(path_575324, "profileName", newJString(profileName))
  result = call_575323.call(path_575324, query_575325, nil, nil, nil)

var profilesGenerateSsoUri* = Call_ProfilesGenerateSsoUri_575315(
    name: "profilesGenerateSsoUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/generateSsoUri",
    validator: validate_ProfilesGenerateSsoUri_575316, base: "",
    url: url_ProfilesGenerateSsoUri_575317, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
