
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: CdnManagementClient
## version: 2016-10-02
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these APIs to manage Azure CDN resources through the Azure Resource Manager. You must make sure that requests made to these resources are secure.
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

  OpenApiRestCall_574466 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574466](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574466): Option[Scheme] {.used.} =
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
  Call_CheckNameAvailability_574688 = ref object of OpenApiRestCall_574466
proc url_CheckNameAvailability_574690(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CheckNameAvailability_574689(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574849 = query.getOrDefault("api-version")
  valid_574849 = validateParameter(valid_574849, JString, required = true,
                                 default = nil)
  if valid_574849 != nil:
    section.add "api-version", valid_574849
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

proc call*(call_574873: Call_CheckNameAvailability_574688; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ## 
  let valid = call_574873.validator(path, query, header, formData, body)
  let scheme = call_574873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574873.url(scheme.get, call_574873.host, call_574873.base,
                         call_574873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574873, url, valid)

proc call*(call_574944: Call_CheckNameAvailability_574688; apiVersion: string;
          checkNameAvailabilityInput: JsonNode): Recallable =
  ## checkNameAvailability
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   checkNameAvailabilityInput: JObject (required)
  ##                             : Input to check.
  var query_574945 = newJObject()
  var body_574947 = newJObject()
  add(query_574945, "api-version", newJString(apiVersion))
  if checkNameAvailabilityInput != nil:
    body_574947 = checkNameAvailabilityInput
  result = call_574944.call(nil, query_574945, nil, nil, body_574947)

var checkNameAvailability* = Call_CheckNameAvailability_574688(
    name: "checkNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Cdn/checkNameAvailability",
    validator: validate_CheckNameAvailability_574689, base: "",
    url: url_CheckNameAvailability_574690, schemes: {Scheme.Https})
type
  Call_EdgeNodesList_574986 = ref object of OpenApiRestCall_574466
proc url_EdgeNodesList_574988(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EdgeNodesList_574987(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the edge nodes of a CDN service.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574989 = query.getOrDefault("api-version")
  valid_574989 = validateParameter(valid_574989, JString, required = true,
                                 default = nil)
  if valid_574989 != nil:
    section.add "api-version", valid_574989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574990: Call_EdgeNodesList_574986; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the edge nodes of a CDN service.
  ## 
  let valid = call_574990.validator(path, query, header, formData, body)
  let scheme = call_574990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574990.url(scheme.get, call_574990.host, call_574990.base,
                         call_574990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574990, url, valid)

proc call*(call_574991: Call_EdgeNodesList_574986; apiVersion: string): Recallable =
  ## edgeNodesList
  ## Lists all the edge nodes of a CDN service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  var query_574992 = newJObject()
  add(query_574992, "api-version", newJString(apiVersion))
  result = call_574991.call(nil, query_574992, nil, nil, nil)

var edgeNodesList* = Call_EdgeNodesList_574986(name: "edgeNodesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Cdn/edgenodes",
    validator: validate_EdgeNodesList_574987, base: "", url: url_EdgeNodesList_574988,
    schemes: {Scheme.Https})
type
  Call_ListOperations_574993 = ref object of OpenApiRestCall_574466
proc url_ListOperations_574995(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListOperations_574994(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available CDN REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
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

proc call*(call_574997: Call_ListOperations_574993; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available CDN REST API operations.
  ## 
  let valid = call_574997.validator(path, query, header, formData, body)
  let scheme = call_574997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574997.url(scheme.get, call_574997.host, call_574997.base,
                         call_574997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574997, url, valid)

proc call*(call_574998: Call_ListOperations_574993; apiVersion: string): Recallable =
  ## listOperations
  ## Lists all of the available CDN REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  var query_574999 = newJObject()
  add(query_574999, "api-version", newJString(apiVersion))
  result = call_574998.call(nil, query_574999, nil, nil, nil)

var listOperations* = Call_ListOperations_574993(name: "listOperations",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Cdn/operations",
    validator: validate_ListOperations_574994, base: "", url: url_ListOperations_574995,
    schemes: {Scheme.Https})
type
  Call_ListResourceUsage_575000 = ref object of OpenApiRestCall_574466
proc url_ListResourceUsage_575002(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Cdn/checkResourceUsage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListResourceUsage_575001(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Check the quota and actual usage of the CDN profiles under the given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575017 = path.getOrDefault("subscriptionId")
  valid_575017 = validateParameter(valid_575017, JString, required = true,
                                 default = nil)
  if valid_575017 != nil:
    section.add "subscriptionId", valid_575017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575018 = query.getOrDefault("api-version")
  valid_575018 = validateParameter(valid_575018, JString, required = true,
                                 default = nil)
  if valid_575018 != nil:
    section.add "api-version", valid_575018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575019: Call_ListResourceUsage_575000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check the quota and actual usage of the CDN profiles under the given subscription.
  ## 
  let valid = call_575019.validator(path, query, header, formData, body)
  let scheme = call_575019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575019.url(scheme.get, call_575019.host, call_575019.base,
                         call_575019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575019, url, valid)

proc call*(call_575020: Call_ListResourceUsage_575000; apiVersion: string;
          subscriptionId: string): Recallable =
  ## listResourceUsage
  ## Check the quota and actual usage of the CDN profiles under the given subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575021 = newJObject()
  var query_575022 = newJObject()
  add(query_575022, "api-version", newJString(apiVersion))
  add(path_575021, "subscriptionId", newJString(subscriptionId))
  result = call_575020.call(path_575021, query_575022, nil, nil, nil)

var listResourceUsage* = Call_ListResourceUsage_575000(name: "listResourceUsage",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/checkResourceUsage",
    validator: validate_ListResourceUsage_575001, base: "",
    url: url_ListResourceUsage_575002, schemes: {Scheme.Https})
type
  Call_ProfilesList_575023 = ref object of OpenApiRestCall_574466
proc url_ProfilesList_575025(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_ProfilesList_575024(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the CDN profiles within an Azure subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575026 = path.getOrDefault("subscriptionId")
  valid_575026 = validateParameter(valid_575026, JString, required = true,
                                 default = nil)
  if valid_575026 != nil:
    section.add "subscriptionId", valid_575026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575027 = query.getOrDefault("api-version")
  valid_575027 = validateParameter(valid_575027, JString, required = true,
                                 default = nil)
  if valid_575027 != nil:
    section.add "api-version", valid_575027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575028: Call_ProfilesList_575023; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the CDN profiles within an Azure subscription.
  ## 
  let valid = call_575028.validator(path, query, header, formData, body)
  let scheme = call_575028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575028.url(scheme.get, call_575028.host, call_575028.base,
                         call_575028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575028, url, valid)

proc call*(call_575029: Call_ProfilesList_575023; apiVersion: string;
          subscriptionId: string): Recallable =
  ## profilesList
  ## Lists all of the CDN profiles within an Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575030 = newJObject()
  var query_575031 = newJObject()
  add(query_575031, "api-version", newJString(apiVersion))
  add(path_575030, "subscriptionId", newJString(subscriptionId))
  result = call_575029.call(path_575030, query_575031, nil, nil, nil)

var profilesList* = Call_ProfilesList_575023(name: "profilesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/profiles",
    validator: validate_ProfilesList_575024, base: "", url: url_ProfilesList_575025,
    schemes: {Scheme.Https})
type
  Call_ProfilesListByResourceGroup_575032 = ref object of OpenApiRestCall_574466
proc url_ProfilesListByResourceGroup_575034(protocol: Scheme; host: string;
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

proc validate_ProfilesListByResourceGroup_575033(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the CDN profiles within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575035 = path.getOrDefault("resourceGroupName")
  valid_575035 = validateParameter(valid_575035, JString, required = true,
                                 default = nil)
  if valid_575035 != nil:
    section.add "resourceGroupName", valid_575035
  var valid_575036 = path.getOrDefault("subscriptionId")
  valid_575036 = validateParameter(valid_575036, JString, required = true,
                                 default = nil)
  if valid_575036 != nil:
    section.add "subscriptionId", valid_575036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575037 = query.getOrDefault("api-version")
  valid_575037 = validateParameter(valid_575037, JString, required = true,
                                 default = nil)
  if valid_575037 != nil:
    section.add "api-version", valid_575037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575038: Call_ProfilesListByResourceGroup_575032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the CDN profiles within a resource group.
  ## 
  let valid = call_575038.validator(path, query, header, formData, body)
  let scheme = call_575038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575038.url(scheme.get, call_575038.host, call_575038.base,
                         call_575038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575038, url, valid)

proc call*(call_575039: Call_ProfilesListByResourceGroup_575032;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## profilesListByResourceGroup
  ## Lists all of the CDN profiles within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575040 = newJObject()
  var query_575041 = newJObject()
  add(path_575040, "resourceGroupName", newJString(resourceGroupName))
  add(query_575041, "api-version", newJString(apiVersion))
  add(path_575040, "subscriptionId", newJString(subscriptionId))
  result = call_575039.call(path_575040, query_575041, nil, nil, nil)

var profilesListByResourceGroup* = Call_ProfilesListByResourceGroup_575032(
    name: "profilesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles",
    validator: validate_ProfilesListByResourceGroup_575033, base: "",
    url: url_ProfilesListByResourceGroup_575034, schemes: {Scheme.Https})
type
  Call_ProfilesCreate_575053 = ref object of OpenApiRestCall_574466
proc url_ProfilesCreate_575055(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesCreate_575054(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a new CDN profile with a profile name under the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575056 = path.getOrDefault("resourceGroupName")
  valid_575056 = validateParameter(valid_575056, JString, required = true,
                                 default = nil)
  if valid_575056 != nil:
    section.add "resourceGroupName", valid_575056
  var valid_575057 = path.getOrDefault("subscriptionId")
  valid_575057 = validateParameter(valid_575057, JString, required = true,
                                 default = nil)
  if valid_575057 != nil:
    section.add "subscriptionId", valid_575057
  var valid_575058 = path.getOrDefault("profileName")
  valid_575058 = validateParameter(valid_575058, JString, required = true,
                                 default = nil)
  if valid_575058 != nil:
    section.add "profileName", valid_575058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575059 = query.getOrDefault("api-version")
  valid_575059 = validateParameter(valid_575059, JString, required = true,
                                 default = nil)
  if valid_575059 != nil:
    section.add "api-version", valid_575059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   profile: JObject (required)
  ##          : Profile properties needed to create a new profile.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575061: Call_ProfilesCreate_575053; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new CDN profile with a profile name under the specified subscription and resource group.
  ## 
  let valid = call_575061.validator(path, query, header, formData, body)
  let scheme = call_575061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575061.url(scheme.get, call_575061.host, call_575061.base,
                         call_575061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575061, url, valid)

proc call*(call_575062: Call_ProfilesCreate_575053; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          profile: JsonNode): Recallable =
  ## profilesCreate
  ## Creates a new CDN profile with a profile name under the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   profile: JObject (required)
  ##          : Profile properties needed to create a new profile.
  var path_575063 = newJObject()
  var query_575064 = newJObject()
  var body_575065 = newJObject()
  add(path_575063, "resourceGroupName", newJString(resourceGroupName))
  add(query_575064, "api-version", newJString(apiVersion))
  add(path_575063, "subscriptionId", newJString(subscriptionId))
  add(path_575063, "profileName", newJString(profileName))
  if profile != nil:
    body_575065 = profile
  result = call_575062.call(path_575063, query_575064, nil, nil, body_575065)

var profilesCreate* = Call_ProfilesCreate_575053(name: "profilesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesCreate_575054, base: "", url: url_ProfilesCreate_575055,
    schemes: {Scheme.Https})
type
  Call_ProfilesGet_575042 = ref object of OpenApiRestCall_574466
proc url_ProfilesGet_575044(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesGet_575043(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575045 = path.getOrDefault("resourceGroupName")
  valid_575045 = validateParameter(valid_575045, JString, required = true,
                                 default = nil)
  if valid_575045 != nil:
    section.add "resourceGroupName", valid_575045
  var valid_575046 = path.getOrDefault("subscriptionId")
  valid_575046 = validateParameter(valid_575046, JString, required = true,
                                 default = nil)
  if valid_575046 != nil:
    section.add "subscriptionId", valid_575046
  var valid_575047 = path.getOrDefault("profileName")
  valid_575047 = validateParameter(valid_575047, JString, required = true,
                                 default = nil)
  if valid_575047 != nil:
    section.add "profileName", valid_575047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575048 = query.getOrDefault("api-version")
  valid_575048 = validateParameter(valid_575048, JString, required = true,
                                 default = nil)
  if valid_575048 != nil:
    section.add "api-version", valid_575048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575049: Call_ProfilesGet_575042; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  let valid = call_575049.validator(path, query, header, formData, body)
  let scheme = call_575049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575049.url(scheme.get, call_575049.host, call_575049.base,
                         call_575049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575049, url, valid)

proc call*(call_575050: Call_ProfilesGet_575042; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string): Recallable =
  ## profilesGet
  ## Gets a CDN profile with the specified profile name under the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_575051 = newJObject()
  var query_575052 = newJObject()
  add(path_575051, "resourceGroupName", newJString(resourceGroupName))
  add(query_575052, "api-version", newJString(apiVersion))
  add(path_575051, "subscriptionId", newJString(subscriptionId))
  add(path_575051, "profileName", newJString(profileName))
  result = call_575050.call(path_575051, query_575052, nil, nil, nil)

var profilesGet* = Call_ProfilesGet_575042(name: "profilesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
                                        validator: validate_ProfilesGet_575043,
                                        base: "", url: url_ProfilesGet_575044,
                                        schemes: {Scheme.Https})
type
  Call_ProfilesUpdate_575077 = ref object of OpenApiRestCall_574466
proc url_ProfilesUpdate_575079(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesUpdate_575078(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates an existing CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575080 = path.getOrDefault("resourceGroupName")
  valid_575080 = validateParameter(valid_575080, JString, required = true,
                                 default = nil)
  if valid_575080 != nil:
    section.add "resourceGroupName", valid_575080
  var valid_575081 = path.getOrDefault("subscriptionId")
  valid_575081 = validateParameter(valid_575081, JString, required = true,
                                 default = nil)
  if valid_575081 != nil:
    section.add "subscriptionId", valid_575081
  var valid_575082 = path.getOrDefault("profileName")
  valid_575082 = validateParameter(valid_575082, JString, required = true,
                                 default = nil)
  if valid_575082 != nil:
    section.add "profileName", valid_575082
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575083 = query.getOrDefault("api-version")
  valid_575083 = validateParameter(valid_575083, JString, required = true,
                                 default = nil)
  if valid_575083 != nil:
    section.add "api-version", valid_575083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   profileUpdateParameters: JObject (required)
  ##                          : Profile properties needed to update an existing profile.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575085: Call_ProfilesUpdate_575077; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  let valid = call_575085.validator(path, query, header, formData, body)
  let scheme = call_575085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575085.url(scheme.get, call_575085.host, call_575085.base,
                         call_575085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575085, url, valid)

proc call*(call_575086: Call_ProfilesUpdate_575077; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          profileUpdateParameters: JsonNode): Recallable =
  ## profilesUpdate
  ## Updates an existing CDN profile with the specified profile name under the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   profileUpdateParameters: JObject (required)
  ##                          : Profile properties needed to update an existing profile.
  var path_575087 = newJObject()
  var query_575088 = newJObject()
  var body_575089 = newJObject()
  add(path_575087, "resourceGroupName", newJString(resourceGroupName))
  add(query_575088, "api-version", newJString(apiVersion))
  add(path_575087, "subscriptionId", newJString(subscriptionId))
  add(path_575087, "profileName", newJString(profileName))
  if profileUpdateParameters != nil:
    body_575089 = profileUpdateParameters
  result = call_575086.call(path_575087, query_575088, nil, nil, body_575089)

var profilesUpdate* = Call_ProfilesUpdate_575077(name: "profilesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesUpdate_575078, base: "", url: url_ProfilesUpdate_575079,
    schemes: {Scheme.Https})
type
  Call_ProfilesDelete_575066 = ref object of OpenApiRestCall_574466
proc url_ProfilesDelete_575068(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesDelete_575067(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes an existing CDN profile with the specified parameters. Deleting a profile will result in the deletion of all of the sub-resources including endpoints, origins and custom domains.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575069 = path.getOrDefault("resourceGroupName")
  valid_575069 = validateParameter(valid_575069, JString, required = true,
                                 default = nil)
  if valid_575069 != nil:
    section.add "resourceGroupName", valid_575069
  var valid_575070 = path.getOrDefault("subscriptionId")
  valid_575070 = validateParameter(valid_575070, JString, required = true,
                                 default = nil)
  if valid_575070 != nil:
    section.add "subscriptionId", valid_575070
  var valid_575071 = path.getOrDefault("profileName")
  valid_575071 = validateParameter(valid_575071, JString, required = true,
                                 default = nil)
  if valid_575071 != nil:
    section.add "profileName", valid_575071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575072 = query.getOrDefault("api-version")
  valid_575072 = validateParameter(valid_575072, JString, required = true,
                                 default = nil)
  if valid_575072 != nil:
    section.add "api-version", valid_575072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575073: Call_ProfilesDelete_575066; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing CDN profile with the specified parameters. Deleting a profile will result in the deletion of all of the sub-resources including endpoints, origins and custom domains.
  ## 
  let valid = call_575073.validator(path, query, header, formData, body)
  let scheme = call_575073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575073.url(scheme.get, call_575073.host, call_575073.base,
                         call_575073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575073, url, valid)

proc call*(call_575074: Call_ProfilesDelete_575066; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string): Recallable =
  ## profilesDelete
  ## Deletes an existing CDN profile with the specified parameters. Deleting a profile will result in the deletion of all of the sub-resources including endpoints, origins and custom domains.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_575075 = newJObject()
  var query_575076 = newJObject()
  add(path_575075, "resourceGroupName", newJString(resourceGroupName))
  add(query_575076, "api-version", newJString(apiVersion))
  add(path_575075, "subscriptionId", newJString(subscriptionId))
  add(path_575075, "profileName", newJString(profileName))
  result = call_575074.call(path_575075, query_575076, nil, nil, nil)

var profilesDelete* = Call_ProfilesDelete_575066(name: "profilesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesDelete_575067, base: "", url: url_ProfilesDelete_575068,
    schemes: {Scheme.Https})
type
  Call_ProfilesListResourceUsage_575090 = ref object of OpenApiRestCall_574466
proc url_ProfilesListResourceUsage_575092(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/checkResourceUsage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesListResourceUsage_575091(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the quota and actual usage of endpoints under the given CDN profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575093 = path.getOrDefault("resourceGroupName")
  valid_575093 = validateParameter(valid_575093, JString, required = true,
                                 default = nil)
  if valid_575093 != nil:
    section.add "resourceGroupName", valid_575093
  var valid_575094 = path.getOrDefault("subscriptionId")
  valid_575094 = validateParameter(valid_575094, JString, required = true,
                                 default = nil)
  if valid_575094 != nil:
    section.add "subscriptionId", valid_575094
  var valid_575095 = path.getOrDefault("profileName")
  valid_575095 = validateParameter(valid_575095, JString, required = true,
                                 default = nil)
  if valid_575095 != nil:
    section.add "profileName", valid_575095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575096 = query.getOrDefault("api-version")
  valid_575096 = validateParameter(valid_575096, JString, required = true,
                                 default = nil)
  if valid_575096 != nil:
    section.add "api-version", valid_575096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575097: Call_ProfilesListResourceUsage_575090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the quota and actual usage of endpoints under the given CDN profile.
  ## 
  let valid = call_575097.validator(path, query, header, formData, body)
  let scheme = call_575097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575097.url(scheme.get, call_575097.host, call_575097.base,
                         call_575097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575097, url, valid)

proc call*(call_575098: Call_ProfilesListResourceUsage_575090;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string): Recallable =
  ## profilesListResourceUsage
  ## Checks the quota and actual usage of endpoints under the given CDN profile.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_575099 = newJObject()
  var query_575100 = newJObject()
  add(path_575099, "resourceGroupName", newJString(resourceGroupName))
  add(query_575100, "api-version", newJString(apiVersion))
  add(path_575099, "subscriptionId", newJString(subscriptionId))
  add(path_575099, "profileName", newJString(profileName))
  result = call_575098.call(path_575099, query_575100, nil, nil, nil)

var profilesListResourceUsage* = Call_ProfilesListResourceUsage_575090(
    name: "profilesListResourceUsage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/checkResourceUsage",
    validator: validate_ProfilesListResourceUsage_575091, base: "",
    url: url_ProfilesListResourceUsage_575092, schemes: {Scheme.Https})
type
  Call_EndpointsListByProfile_575101 = ref object of OpenApiRestCall_574466
proc url_EndpointsListByProfile_575103(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsListByProfile_575102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists existing CDN endpoints.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575104 = path.getOrDefault("resourceGroupName")
  valid_575104 = validateParameter(valid_575104, JString, required = true,
                                 default = nil)
  if valid_575104 != nil:
    section.add "resourceGroupName", valid_575104
  var valid_575105 = path.getOrDefault("subscriptionId")
  valid_575105 = validateParameter(valid_575105, JString, required = true,
                                 default = nil)
  if valid_575105 != nil:
    section.add "subscriptionId", valid_575105
  var valid_575106 = path.getOrDefault("profileName")
  valid_575106 = validateParameter(valid_575106, JString, required = true,
                                 default = nil)
  if valid_575106 != nil:
    section.add "profileName", valid_575106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
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
  if body != nil:
    result.add "body", body

proc call*(call_575108: Call_EndpointsListByProfile_575101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists existing CDN endpoints.
  ## 
  let valid = call_575108.validator(path, query, header, formData, body)
  let scheme = call_575108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575108.url(scheme.get, call_575108.host, call_575108.base,
                         call_575108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575108, url, valid)

proc call*(call_575109: Call_EndpointsListByProfile_575101;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string): Recallable =
  ## endpointsListByProfile
  ## Lists existing CDN endpoints.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_575110 = newJObject()
  var query_575111 = newJObject()
  add(path_575110, "resourceGroupName", newJString(resourceGroupName))
  add(query_575111, "api-version", newJString(apiVersion))
  add(path_575110, "subscriptionId", newJString(subscriptionId))
  add(path_575110, "profileName", newJString(profileName))
  result = call_575109.call(path_575110, query_575111, nil, nil, nil)

var endpointsListByProfile* = Call_EndpointsListByProfile_575101(
    name: "endpointsListByProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints",
    validator: validate_EndpointsListByProfile_575102, base: "",
    url: url_EndpointsListByProfile_575103, schemes: {Scheme.Https})
type
  Call_EndpointsCreate_575124 = ref object of OpenApiRestCall_574466
proc url_EndpointsCreate_575126(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsCreate_575125(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Creates a new CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575127 = path.getOrDefault("resourceGroupName")
  valid_575127 = validateParameter(valid_575127, JString, required = true,
                                 default = nil)
  if valid_575127 != nil:
    section.add "resourceGroupName", valid_575127
  var valid_575128 = path.getOrDefault("subscriptionId")
  valid_575128 = validateParameter(valid_575128, JString, required = true,
                                 default = nil)
  if valid_575128 != nil:
    section.add "subscriptionId", valid_575128
  var valid_575129 = path.getOrDefault("profileName")
  valid_575129 = validateParameter(valid_575129, JString, required = true,
                                 default = nil)
  if valid_575129 != nil:
    section.add "profileName", valid_575129
  var valid_575130 = path.getOrDefault("endpointName")
  valid_575130 = validateParameter(valid_575130, JString, required = true,
                                 default = nil)
  if valid_575130 != nil:
    section.add "endpointName", valid_575130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575131 = query.getOrDefault("api-version")
  valid_575131 = validateParameter(valid_575131, JString, required = true,
                                 default = nil)
  if valid_575131 != nil:
    section.add "api-version", valid_575131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   endpoint: JObject (required)
  ##           : Endpoint properties
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575133: Call_EndpointsCreate_575124; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  let valid = call_575133.validator(path, query, header, formData, body)
  let scheme = call_575133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575133.url(scheme.get, call_575133.host, call_575133.base,
                         call_575133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575133, url, valid)

proc call*(call_575134: Call_EndpointsCreate_575124; resourceGroupName: string;
          apiVersion: string; endpoint: JsonNode; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## endpointsCreate
  ## Creates a new CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   endpoint: JObject (required)
  ##           : Endpoint properties
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575135 = newJObject()
  var query_575136 = newJObject()
  var body_575137 = newJObject()
  add(path_575135, "resourceGroupName", newJString(resourceGroupName))
  add(query_575136, "api-version", newJString(apiVersion))
  if endpoint != nil:
    body_575137 = endpoint
  add(path_575135, "subscriptionId", newJString(subscriptionId))
  add(path_575135, "profileName", newJString(profileName))
  add(path_575135, "endpointName", newJString(endpointName))
  result = call_575134.call(path_575135, query_575136, nil, nil, body_575137)

var endpointsCreate* = Call_EndpointsCreate_575124(name: "endpointsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsCreate_575125, base: "", url: url_EndpointsCreate_575126,
    schemes: {Scheme.Https})
type
  Call_EndpointsGet_575112 = ref object of OpenApiRestCall_574466
proc url_EndpointsGet_575114(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsGet_575113(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575115 = path.getOrDefault("resourceGroupName")
  valid_575115 = validateParameter(valid_575115, JString, required = true,
                                 default = nil)
  if valid_575115 != nil:
    section.add "resourceGroupName", valid_575115
  var valid_575116 = path.getOrDefault("subscriptionId")
  valid_575116 = validateParameter(valid_575116, JString, required = true,
                                 default = nil)
  if valid_575116 != nil:
    section.add "subscriptionId", valid_575116
  var valid_575117 = path.getOrDefault("profileName")
  valid_575117 = validateParameter(valid_575117, JString, required = true,
                                 default = nil)
  if valid_575117 != nil:
    section.add "profileName", valid_575117
  var valid_575118 = path.getOrDefault("endpointName")
  valid_575118 = validateParameter(valid_575118, JString, required = true,
                                 default = nil)
  if valid_575118 != nil:
    section.add "endpointName", valid_575118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575119 = query.getOrDefault("api-version")
  valid_575119 = validateParameter(valid_575119, JString, required = true,
                                 default = nil)
  if valid_575119 != nil:
    section.add "api-version", valid_575119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575120: Call_EndpointsGet_575112; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  let valid = call_575120.validator(path, query, header, formData, body)
  let scheme = call_575120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575120.url(scheme.get, call_575120.host, call_575120.base,
                         call_575120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575120, url, valid)

proc call*(call_575121: Call_EndpointsGet_575112; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          endpointName: string): Recallable =
  ## endpointsGet
  ## Gets an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575122 = newJObject()
  var query_575123 = newJObject()
  add(path_575122, "resourceGroupName", newJString(resourceGroupName))
  add(query_575123, "api-version", newJString(apiVersion))
  add(path_575122, "subscriptionId", newJString(subscriptionId))
  add(path_575122, "profileName", newJString(profileName))
  add(path_575122, "endpointName", newJString(endpointName))
  result = call_575121.call(path_575122, query_575123, nil, nil, nil)

var endpointsGet* = Call_EndpointsGet_575112(name: "endpointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsGet_575113, base: "", url: url_EndpointsGet_575114,
    schemes: {Scheme.Https})
type
  Call_EndpointsUpdate_575150 = ref object of OpenApiRestCall_574466
proc url_EndpointsUpdate_575152(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsUpdate_575151(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile. Only tags and Origin HostHeader can be updated after creating an endpoint. To update origins, use the Update Origin operation. To update custom domains, use the Update Custom Domain operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575153 = path.getOrDefault("resourceGroupName")
  valid_575153 = validateParameter(valid_575153, JString, required = true,
                                 default = nil)
  if valid_575153 != nil:
    section.add "resourceGroupName", valid_575153
  var valid_575154 = path.getOrDefault("subscriptionId")
  valid_575154 = validateParameter(valid_575154, JString, required = true,
                                 default = nil)
  if valid_575154 != nil:
    section.add "subscriptionId", valid_575154
  var valid_575155 = path.getOrDefault("profileName")
  valid_575155 = validateParameter(valid_575155, JString, required = true,
                                 default = nil)
  if valid_575155 != nil:
    section.add "profileName", valid_575155
  var valid_575156 = path.getOrDefault("endpointName")
  valid_575156 = validateParameter(valid_575156, JString, required = true,
                                 default = nil)
  if valid_575156 != nil:
    section.add "endpointName", valid_575156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575157 = query.getOrDefault("api-version")
  valid_575157 = validateParameter(valid_575157, JString, required = true,
                                 default = nil)
  if valid_575157 != nil:
    section.add "api-version", valid_575157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   endpointUpdateProperties: JObject (required)
  ##                           : Endpoint update properties
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575159: Call_EndpointsUpdate_575150; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile. Only tags and Origin HostHeader can be updated after creating an endpoint. To update origins, use the Update Origin operation. To update custom domains, use the Update Custom Domain operation.
  ## 
  let valid = call_575159.validator(path, query, header, formData, body)
  let scheme = call_575159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575159.url(scheme.get, call_575159.host, call_575159.base,
                         call_575159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575159, url, valid)

proc call*(call_575160: Call_EndpointsUpdate_575150; resourceGroupName: string;
          endpointUpdateProperties: JsonNode; apiVersion: string;
          subscriptionId: string; profileName: string; endpointName: string): Recallable =
  ## endpointsUpdate
  ## Updates an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile. Only tags and Origin HostHeader can be updated after creating an endpoint. To update origins, use the Update Origin operation. To update custom domains, use the Update Custom Domain operation.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointUpdateProperties: JObject (required)
  ##                           : Endpoint update properties
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575161 = newJObject()
  var query_575162 = newJObject()
  var body_575163 = newJObject()
  add(path_575161, "resourceGroupName", newJString(resourceGroupName))
  if endpointUpdateProperties != nil:
    body_575163 = endpointUpdateProperties
  add(query_575162, "api-version", newJString(apiVersion))
  add(path_575161, "subscriptionId", newJString(subscriptionId))
  add(path_575161, "profileName", newJString(profileName))
  add(path_575161, "endpointName", newJString(endpointName))
  result = call_575160.call(path_575161, query_575162, nil, nil, body_575163)

var endpointsUpdate* = Call_EndpointsUpdate_575150(name: "endpointsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsUpdate_575151, base: "", url: url_EndpointsUpdate_575152,
    schemes: {Scheme.Https})
type
  Call_EndpointsDelete_575138 = ref object of OpenApiRestCall_574466
proc url_EndpointsDelete_575140(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsDelete_575139(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
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
  var valid_575143 = path.getOrDefault("profileName")
  valid_575143 = validateParameter(valid_575143, JString, required = true,
                                 default = nil)
  if valid_575143 != nil:
    section.add "profileName", valid_575143
  var valid_575144 = path.getOrDefault("endpointName")
  valid_575144 = validateParameter(valid_575144, JString, required = true,
                                 default = nil)
  if valid_575144 != nil:
    section.add "endpointName", valid_575144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575145 = query.getOrDefault("api-version")
  valid_575145 = validateParameter(valid_575145, JString, required = true,
                                 default = nil)
  if valid_575145 != nil:
    section.add "api-version", valid_575145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575146: Call_EndpointsDelete_575138; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  let valid = call_575146.validator(path, query, header, formData, body)
  let scheme = call_575146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575146.url(scheme.get, call_575146.host, call_575146.base,
                         call_575146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575146, url, valid)

proc call*(call_575147: Call_EndpointsDelete_575138; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          endpointName: string): Recallable =
  ## endpointsDelete
  ## Deletes an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575148 = newJObject()
  var query_575149 = newJObject()
  add(path_575148, "resourceGroupName", newJString(resourceGroupName))
  add(query_575149, "api-version", newJString(apiVersion))
  add(path_575148, "subscriptionId", newJString(subscriptionId))
  add(path_575148, "profileName", newJString(profileName))
  add(path_575148, "endpointName", newJString(endpointName))
  result = call_575147.call(path_575148, query_575149, nil, nil, nil)

var endpointsDelete* = Call_EndpointsDelete_575138(name: "endpointsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsDelete_575139, base: "", url: url_EndpointsDelete_575140,
    schemes: {Scheme.Https})
type
  Call_EndpointsListResourceUsage_575164 = ref object of OpenApiRestCall_574466
proc url_EndpointsListResourceUsage_575166(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/checkResourceUsage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsListResourceUsage_575165(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the quota and usage of geo filters and custom domains under the given endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575167 = path.getOrDefault("resourceGroupName")
  valid_575167 = validateParameter(valid_575167, JString, required = true,
                                 default = nil)
  if valid_575167 != nil:
    section.add "resourceGroupName", valid_575167
  var valid_575168 = path.getOrDefault("subscriptionId")
  valid_575168 = validateParameter(valid_575168, JString, required = true,
                                 default = nil)
  if valid_575168 != nil:
    section.add "subscriptionId", valid_575168
  var valid_575169 = path.getOrDefault("profileName")
  valid_575169 = validateParameter(valid_575169, JString, required = true,
                                 default = nil)
  if valid_575169 != nil:
    section.add "profileName", valid_575169
  var valid_575170 = path.getOrDefault("endpointName")
  valid_575170 = validateParameter(valid_575170, JString, required = true,
                                 default = nil)
  if valid_575170 != nil:
    section.add "endpointName", valid_575170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575171 = query.getOrDefault("api-version")
  valid_575171 = validateParameter(valid_575171, JString, required = true,
                                 default = nil)
  if valid_575171 != nil:
    section.add "api-version", valid_575171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575172: Call_EndpointsListResourceUsage_575164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the quota and usage of geo filters and custom domains under the given endpoint.
  ## 
  let valid = call_575172.validator(path, query, header, formData, body)
  let scheme = call_575172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575172.url(scheme.get, call_575172.host, call_575172.base,
                         call_575172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575172, url, valid)

proc call*(call_575173: Call_EndpointsListResourceUsage_575164;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## endpointsListResourceUsage
  ## Checks the quota and usage of geo filters and custom domains under the given endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575174 = newJObject()
  var query_575175 = newJObject()
  add(path_575174, "resourceGroupName", newJString(resourceGroupName))
  add(query_575175, "api-version", newJString(apiVersion))
  add(path_575174, "subscriptionId", newJString(subscriptionId))
  add(path_575174, "profileName", newJString(profileName))
  add(path_575174, "endpointName", newJString(endpointName))
  result = call_575173.call(path_575174, query_575175, nil, nil, nil)

var endpointsListResourceUsage* = Call_EndpointsListResourceUsage_575164(
    name: "endpointsListResourceUsage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/checkResourceUsage",
    validator: validate_EndpointsListResourceUsage_575165, base: "",
    url: url_EndpointsListResourceUsage_575166, schemes: {Scheme.Https})
type
  Call_CustomDomainsListByEndpoint_575176 = ref object of OpenApiRestCall_574466
proc url_CustomDomainsListByEndpoint_575178(protocol: Scheme; host: string;
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

proc validate_CustomDomainsListByEndpoint_575177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the existing custom domains within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575179 = path.getOrDefault("resourceGroupName")
  valid_575179 = validateParameter(valid_575179, JString, required = true,
                                 default = nil)
  if valid_575179 != nil:
    section.add "resourceGroupName", valid_575179
  var valid_575180 = path.getOrDefault("subscriptionId")
  valid_575180 = validateParameter(valid_575180, JString, required = true,
                                 default = nil)
  if valid_575180 != nil:
    section.add "subscriptionId", valid_575180
  var valid_575181 = path.getOrDefault("profileName")
  valid_575181 = validateParameter(valid_575181, JString, required = true,
                                 default = nil)
  if valid_575181 != nil:
    section.add "profileName", valid_575181
  var valid_575182 = path.getOrDefault("endpointName")
  valid_575182 = validateParameter(valid_575182, JString, required = true,
                                 default = nil)
  if valid_575182 != nil:
    section.add "endpointName", valid_575182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575183 = query.getOrDefault("api-version")
  valid_575183 = validateParameter(valid_575183, JString, required = true,
                                 default = nil)
  if valid_575183 != nil:
    section.add "api-version", valid_575183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575184: Call_CustomDomainsListByEndpoint_575176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the existing custom domains within an endpoint.
  ## 
  let valid = call_575184.validator(path, query, header, formData, body)
  let scheme = call_575184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575184.url(scheme.get, call_575184.host, call_575184.base,
                         call_575184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575184, url, valid)

proc call*(call_575185: Call_CustomDomainsListByEndpoint_575176;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## customDomainsListByEndpoint
  ## Lists all of the existing custom domains within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575186 = newJObject()
  var query_575187 = newJObject()
  add(path_575186, "resourceGroupName", newJString(resourceGroupName))
  add(query_575187, "api-version", newJString(apiVersion))
  add(path_575186, "subscriptionId", newJString(subscriptionId))
  add(path_575186, "profileName", newJString(profileName))
  add(path_575186, "endpointName", newJString(endpointName))
  result = call_575185.call(path_575186, query_575187, nil, nil, nil)

var customDomainsListByEndpoint* = Call_CustomDomainsListByEndpoint_575176(
    name: "customDomainsListByEndpoint", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains",
    validator: validate_CustomDomainsListByEndpoint_575177, base: "",
    url: url_CustomDomainsListByEndpoint_575178, schemes: {Scheme.Https})
type
  Call_CustomDomainsCreate_575201 = ref object of OpenApiRestCall_574466
proc url_CustomDomainsCreate_575203(protocol: Scheme; host: string; base: string;
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

proc validate_CustomDomainsCreate_575202(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new custom domain within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575204 = path.getOrDefault("resourceGroupName")
  valid_575204 = validateParameter(valid_575204, JString, required = true,
                                 default = nil)
  if valid_575204 != nil:
    section.add "resourceGroupName", valid_575204
  var valid_575205 = path.getOrDefault("subscriptionId")
  valid_575205 = validateParameter(valid_575205, JString, required = true,
                                 default = nil)
  if valid_575205 != nil:
    section.add "subscriptionId", valid_575205
  var valid_575206 = path.getOrDefault("customDomainName")
  valid_575206 = validateParameter(valid_575206, JString, required = true,
                                 default = nil)
  if valid_575206 != nil:
    section.add "customDomainName", valid_575206
  var valid_575207 = path.getOrDefault("profileName")
  valid_575207 = validateParameter(valid_575207, JString, required = true,
                                 default = nil)
  if valid_575207 != nil:
    section.add "profileName", valid_575207
  var valid_575208 = path.getOrDefault("endpointName")
  valid_575208 = validateParameter(valid_575208, JString, required = true,
                                 default = nil)
  if valid_575208 != nil:
    section.add "endpointName", valid_575208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575209 = query.getOrDefault("api-version")
  valid_575209 = validateParameter(valid_575209, JString, required = true,
                                 default = nil)
  if valid_575209 != nil:
    section.add "api-version", valid_575209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customDomainProperties: JObject (required)
  ##                         : Properties required to create a new custom domain.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575211: Call_CustomDomainsCreate_575201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new custom domain within an endpoint.
  ## 
  let valid = call_575211.validator(path, query, header, formData, body)
  let scheme = call_575211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575211.url(scheme.get, call_575211.host, call_575211.base,
                         call_575211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575211, url, valid)

proc call*(call_575212: Call_CustomDomainsCreate_575201; resourceGroupName: string;
          apiVersion: string; customDomainProperties: JsonNode;
          subscriptionId: string; customDomainName: string; profileName: string;
          endpointName: string): Recallable =
  ## customDomainsCreate
  ## Creates a new custom domain within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   customDomainProperties: JObject (required)
  ##                         : Properties required to create a new custom domain.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575213 = newJObject()
  var query_575214 = newJObject()
  var body_575215 = newJObject()
  add(path_575213, "resourceGroupName", newJString(resourceGroupName))
  add(query_575214, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_575215 = customDomainProperties
  add(path_575213, "subscriptionId", newJString(subscriptionId))
  add(path_575213, "customDomainName", newJString(customDomainName))
  add(path_575213, "profileName", newJString(profileName))
  add(path_575213, "endpointName", newJString(endpointName))
  result = call_575212.call(path_575213, query_575214, nil, nil, body_575215)

var customDomainsCreate* = Call_CustomDomainsCreate_575201(
    name: "customDomainsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsCreate_575202, base: "",
    url: url_CustomDomainsCreate_575203, schemes: {Scheme.Https})
type
  Call_CustomDomainsGet_575188 = ref object of OpenApiRestCall_574466
proc url_CustomDomainsGet_575190(protocol: Scheme; host: string; base: string;
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

proc validate_CustomDomainsGet_575189(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets an existing custom domain within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575191 = path.getOrDefault("resourceGroupName")
  valid_575191 = validateParameter(valid_575191, JString, required = true,
                                 default = nil)
  if valid_575191 != nil:
    section.add "resourceGroupName", valid_575191
  var valid_575192 = path.getOrDefault("subscriptionId")
  valid_575192 = validateParameter(valid_575192, JString, required = true,
                                 default = nil)
  if valid_575192 != nil:
    section.add "subscriptionId", valid_575192
  var valid_575193 = path.getOrDefault("customDomainName")
  valid_575193 = validateParameter(valid_575193, JString, required = true,
                                 default = nil)
  if valid_575193 != nil:
    section.add "customDomainName", valid_575193
  var valid_575194 = path.getOrDefault("profileName")
  valid_575194 = validateParameter(valid_575194, JString, required = true,
                                 default = nil)
  if valid_575194 != nil:
    section.add "profileName", valid_575194
  var valid_575195 = path.getOrDefault("endpointName")
  valid_575195 = validateParameter(valid_575195, JString, required = true,
                                 default = nil)
  if valid_575195 != nil:
    section.add "endpointName", valid_575195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575196 = query.getOrDefault("api-version")
  valid_575196 = validateParameter(valid_575196, JString, required = true,
                                 default = nil)
  if valid_575196 != nil:
    section.add "api-version", valid_575196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575197: Call_CustomDomainsGet_575188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing custom domain within an endpoint.
  ## 
  let valid = call_575197.validator(path, query, header, formData, body)
  let scheme = call_575197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575197.url(scheme.get, call_575197.host, call_575197.base,
                         call_575197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575197, url, valid)

proc call*(call_575198: Call_CustomDomainsGet_575188; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; customDomainName: string;
          profileName: string; endpointName: string): Recallable =
  ## customDomainsGet
  ## Gets an existing custom domain within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575199 = newJObject()
  var query_575200 = newJObject()
  add(path_575199, "resourceGroupName", newJString(resourceGroupName))
  add(query_575200, "api-version", newJString(apiVersion))
  add(path_575199, "subscriptionId", newJString(subscriptionId))
  add(path_575199, "customDomainName", newJString(customDomainName))
  add(path_575199, "profileName", newJString(profileName))
  add(path_575199, "endpointName", newJString(endpointName))
  result = call_575198.call(path_575199, query_575200, nil, nil, nil)

var customDomainsGet* = Call_CustomDomainsGet_575188(name: "customDomainsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsGet_575189, base: "",
    url: url_CustomDomainsGet_575190, schemes: {Scheme.Https})
type
  Call_CustomDomainsDelete_575216 = ref object of OpenApiRestCall_574466
proc url_CustomDomainsDelete_575218(protocol: Scheme; host: string; base: string;
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

proc validate_CustomDomainsDelete_575217(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes an existing custom domain within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575219 = path.getOrDefault("resourceGroupName")
  valid_575219 = validateParameter(valid_575219, JString, required = true,
                                 default = nil)
  if valid_575219 != nil:
    section.add "resourceGroupName", valid_575219
  var valid_575220 = path.getOrDefault("subscriptionId")
  valid_575220 = validateParameter(valid_575220, JString, required = true,
                                 default = nil)
  if valid_575220 != nil:
    section.add "subscriptionId", valid_575220
  var valid_575221 = path.getOrDefault("customDomainName")
  valid_575221 = validateParameter(valid_575221, JString, required = true,
                                 default = nil)
  if valid_575221 != nil:
    section.add "customDomainName", valid_575221
  var valid_575222 = path.getOrDefault("profileName")
  valid_575222 = validateParameter(valid_575222, JString, required = true,
                                 default = nil)
  if valid_575222 != nil:
    section.add "profileName", valid_575222
  var valid_575223 = path.getOrDefault("endpointName")
  valid_575223 = validateParameter(valid_575223, JString, required = true,
                                 default = nil)
  if valid_575223 != nil:
    section.add "endpointName", valid_575223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
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

proc call*(call_575225: Call_CustomDomainsDelete_575216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing custom domain within an endpoint.
  ## 
  let valid = call_575225.validator(path, query, header, formData, body)
  let scheme = call_575225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575225.url(scheme.get, call_575225.host, call_575225.base,
                         call_575225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575225, url, valid)

proc call*(call_575226: Call_CustomDomainsDelete_575216; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; customDomainName: string;
          profileName: string; endpointName: string): Recallable =
  ## customDomainsDelete
  ## Deletes an existing custom domain within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575227 = newJObject()
  var query_575228 = newJObject()
  add(path_575227, "resourceGroupName", newJString(resourceGroupName))
  add(query_575228, "api-version", newJString(apiVersion))
  add(path_575227, "subscriptionId", newJString(subscriptionId))
  add(path_575227, "customDomainName", newJString(customDomainName))
  add(path_575227, "profileName", newJString(profileName))
  add(path_575227, "endpointName", newJString(endpointName))
  result = call_575226.call(path_575227, query_575228, nil, nil, nil)

var customDomainsDelete* = Call_CustomDomainsDelete_575216(
    name: "customDomainsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsDelete_575217, base: "",
    url: url_CustomDomainsDelete_575218, schemes: {Scheme.Https})
type
  Call_CustomDomainsDisableCustomHttps_575229 = ref object of OpenApiRestCall_574466
proc url_CustomDomainsDisableCustomHttps_575231(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "customDomainName"),
               (kind: ConstantSegment, value: "/disableCustomHttps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsDisableCustomHttps_575230(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Disable https delivery of the custom domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575232 = path.getOrDefault("resourceGroupName")
  valid_575232 = validateParameter(valid_575232, JString, required = true,
                                 default = nil)
  if valid_575232 != nil:
    section.add "resourceGroupName", valid_575232
  var valid_575233 = path.getOrDefault("subscriptionId")
  valid_575233 = validateParameter(valid_575233, JString, required = true,
                                 default = nil)
  if valid_575233 != nil:
    section.add "subscriptionId", valid_575233
  var valid_575234 = path.getOrDefault("customDomainName")
  valid_575234 = validateParameter(valid_575234, JString, required = true,
                                 default = nil)
  if valid_575234 != nil:
    section.add "customDomainName", valid_575234
  var valid_575235 = path.getOrDefault("profileName")
  valid_575235 = validateParameter(valid_575235, JString, required = true,
                                 default = nil)
  if valid_575235 != nil:
    section.add "profileName", valid_575235
  var valid_575236 = path.getOrDefault("endpointName")
  valid_575236 = validateParameter(valid_575236, JString, required = true,
                                 default = nil)
  if valid_575236 != nil:
    section.add "endpointName", valid_575236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575237 = query.getOrDefault("api-version")
  valid_575237 = validateParameter(valid_575237, JString, required = true,
                                 default = nil)
  if valid_575237 != nil:
    section.add "api-version", valid_575237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575238: Call_CustomDomainsDisableCustomHttps_575229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disable https delivery of the custom domain.
  ## 
  let valid = call_575238.validator(path, query, header, formData, body)
  let scheme = call_575238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575238.url(scheme.get, call_575238.host, call_575238.base,
                         call_575238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575238, url, valid)

proc call*(call_575239: Call_CustomDomainsDisableCustomHttps_575229;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          customDomainName: string; profileName: string; endpointName: string): Recallable =
  ## customDomainsDisableCustomHttps
  ## Disable https delivery of the custom domain.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575240 = newJObject()
  var query_575241 = newJObject()
  add(path_575240, "resourceGroupName", newJString(resourceGroupName))
  add(query_575241, "api-version", newJString(apiVersion))
  add(path_575240, "subscriptionId", newJString(subscriptionId))
  add(path_575240, "customDomainName", newJString(customDomainName))
  add(path_575240, "profileName", newJString(profileName))
  add(path_575240, "endpointName", newJString(endpointName))
  result = call_575239.call(path_575240, query_575241, nil, nil, nil)

var customDomainsDisableCustomHttps* = Call_CustomDomainsDisableCustomHttps_575229(
    name: "customDomainsDisableCustomHttps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}/disableCustomHttps",
    validator: validate_CustomDomainsDisableCustomHttps_575230, base: "",
    url: url_CustomDomainsDisableCustomHttps_575231, schemes: {Scheme.Https})
type
  Call_CustomDomainsEnableCustomHttps_575242 = ref object of OpenApiRestCall_574466
proc url_CustomDomainsEnableCustomHttps_575244(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "customDomainName"),
               (kind: ConstantSegment, value: "/enableCustomHttps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsEnableCustomHttps_575243(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enable https delivery of the custom domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575245 = path.getOrDefault("resourceGroupName")
  valid_575245 = validateParameter(valid_575245, JString, required = true,
                                 default = nil)
  if valid_575245 != nil:
    section.add "resourceGroupName", valid_575245
  var valid_575246 = path.getOrDefault("subscriptionId")
  valid_575246 = validateParameter(valid_575246, JString, required = true,
                                 default = nil)
  if valid_575246 != nil:
    section.add "subscriptionId", valid_575246
  var valid_575247 = path.getOrDefault("customDomainName")
  valid_575247 = validateParameter(valid_575247, JString, required = true,
                                 default = nil)
  if valid_575247 != nil:
    section.add "customDomainName", valid_575247
  var valid_575248 = path.getOrDefault("profileName")
  valid_575248 = validateParameter(valid_575248, JString, required = true,
                                 default = nil)
  if valid_575248 != nil:
    section.add "profileName", valid_575248
  var valid_575249 = path.getOrDefault("endpointName")
  valid_575249 = validateParameter(valid_575249, JString, required = true,
                                 default = nil)
  if valid_575249 != nil:
    section.add "endpointName", valid_575249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575250 = query.getOrDefault("api-version")
  valid_575250 = validateParameter(valid_575250, JString, required = true,
                                 default = nil)
  if valid_575250 != nil:
    section.add "api-version", valid_575250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575251: Call_CustomDomainsEnableCustomHttps_575242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enable https delivery of the custom domain.
  ## 
  let valid = call_575251.validator(path, query, header, formData, body)
  let scheme = call_575251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575251.url(scheme.get, call_575251.host, call_575251.base,
                         call_575251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575251, url, valid)

proc call*(call_575252: Call_CustomDomainsEnableCustomHttps_575242;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          customDomainName: string; profileName: string; endpointName: string): Recallable =
  ## customDomainsEnableCustomHttps
  ## Enable https delivery of the custom domain.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575253 = newJObject()
  var query_575254 = newJObject()
  add(path_575253, "resourceGroupName", newJString(resourceGroupName))
  add(query_575254, "api-version", newJString(apiVersion))
  add(path_575253, "subscriptionId", newJString(subscriptionId))
  add(path_575253, "customDomainName", newJString(customDomainName))
  add(path_575253, "profileName", newJString(profileName))
  add(path_575253, "endpointName", newJString(endpointName))
  result = call_575252.call(path_575253, query_575254, nil, nil, nil)

var customDomainsEnableCustomHttps* = Call_CustomDomainsEnableCustomHttps_575242(
    name: "customDomainsEnableCustomHttps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}/enableCustomHttps",
    validator: validate_CustomDomainsEnableCustomHttps_575243, base: "",
    url: url_CustomDomainsEnableCustomHttps_575244, schemes: {Scheme.Https})
type
  Call_EndpointsLoadContent_575255 = ref object of OpenApiRestCall_574466
proc url_EndpointsLoadContent_575257(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsLoadContent_575256(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pre-loads a content to CDN. Available for Verizon Profiles.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575258 = path.getOrDefault("resourceGroupName")
  valid_575258 = validateParameter(valid_575258, JString, required = true,
                                 default = nil)
  if valid_575258 != nil:
    section.add "resourceGroupName", valid_575258
  var valid_575259 = path.getOrDefault("subscriptionId")
  valid_575259 = validateParameter(valid_575259, JString, required = true,
                                 default = nil)
  if valid_575259 != nil:
    section.add "subscriptionId", valid_575259
  var valid_575260 = path.getOrDefault("profileName")
  valid_575260 = validateParameter(valid_575260, JString, required = true,
                                 default = nil)
  if valid_575260 != nil:
    section.add "profileName", valid_575260
  var valid_575261 = path.getOrDefault("endpointName")
  valid_575261 = validateParameter(valid_575261, JString, required = true,
                                 default = nil)
  if valid_575261 != nil:
    section.add "endpointName", valid_575261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575262 = query.getOrDefault("api-version")
  valid_575262 = validateParameter(valid_575262, JString, required = true,
                                 default = nil)
  if valid_575262 != nil:
    section.add "api-version", valid_575262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be loaded. Path should be a full URL, e.g. ‘/pictures/city.png' which loads a single file 
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575264: Call_EndpointsLoadContent_575255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pre-loads a content to CDN. Available for Verizon Profiles.
  ## 
  let valid = call_575264.validator(path, query, header, formData, body)
  let scheme = call_575264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575264.url(scheme.get, call_575264.host, call_575264.base,
                         call_575264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575264, url, valid)

proc call*(call_575265: Call_EndpointsLoadContent_575255;
          resourceGroupName: string; contentFilePaths: JsonNode; apiVersion: string;
          subscriptionId: string; profileName: string; endpointName: string): Recallable =
  ## endpointsLoadContent
  ## Pre-loads a content to CDN. Available for Verizon Profiles.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be loaded. Path should be a full URL, e.g. ‘/pictures/city.png' which loads a single file 
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575266 = newJObject()
  var query_575267 = newJObject()
  var body_575268 = newJObject()
  add(path_575266, "resourceGroupName", newJString(resourceGroupName))
  if contentFilePaths != nil:
    body_575268 = contentFilePaths
  add(query_575267, "api-version", newJString(apiVersion))
  add(path_575266, "subscriptionId", newJString(subscriptionId))
  add(path_575266, "profileName", newJString(profileName))
  add(path_575266, "endpointName", newJString(endpointName))
  result = call_575265.call(path_575266, query_575267, nil, nil, body_575268)

var endpointsLoadContent* = Call_EndpointsLoadContent_575255(
    name: "endpointsLoadContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/load",
    validator: validate_EndpointsLoadContent_575256, base: "",
    url: url_EndpointsLoadContent_575257, schemes: {Scheme.Https})
type
  Call_OriginsListByEndpoint_575269 = ref object of OpenApiRestCall_574466
proc url_OriginsListByEndpoint_575271(protocol: Scheme; host: string; base: string;
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

proc validate_OriginsListByEndpoint_575270(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the existing origins within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575272 = path.getOrDefault("resourceGroupName")
  valid_575272 = validateParameter(valid_575272, JString, required = true,
                                 default = nil)
  if valid_575272 != nil:
    section.add "resourceGroupName", valid_575272
  var valid_575273 = path.getOrDefault("subscriptionId")
  valid_575273 = validateParameter(valid_575273, JString, required = true,
                                 default = nil)
  if valid_575273 != nil:
    section.add "subscriptionId", valid_575273
  var valid_575274 = path.getOrDefault("profileName")
  valid_575274 = validateParameter(valid_575274, JString, required = true,
                                 default = nil)
  if valid_575274 != nil:
    section.add "profileName", valid_575274
  var valid_575275 = path.getOrDefault("endpointName")
  valid_575275 = validateParameter(valid_575275, JString, required = true,
                                 default = nil)
  if valid_575275 != nil:
    section.add "endpointName", valid_575275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575276 = query.getOrDefault("api-version")
  valid_575276 = validateParameter(valid_575276, JString, required = true,
                                 default = nil)
  if valid_575276 != nil:
    section.add "api-version", valid_575276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575277: Call_OriginsListByEndpoint_575269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the existing origins within an endpoint.
  ## 
  let valid = call_575277.validator(path, query, header, formData, body)
  let scheme = call_575277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575277.url(scheme.get, call_575277.host, call_575277.base,
                         call_575277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575277, url, valid)

proc call*(call_575278: Call_OriginsListByEndpoint_575269;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## originsListByEndpoint
  ## Lists all of the existing origins within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575279 = newJObject()
  var query_575280 = newJObject()
  add(path_575279, "resourceGroupName", newJString(resourceGroupName))
  add(query_575280, "api-version", newJString(apiVersion))
  add(path_575279, "subscriptionId", newJString(subscriptionId))
  add(path_575279, "profileName", newJString(profileName))
  add(path_575279, "endpointName", newJString(endpointName))
  result = call_575278.call(path_575279, query_575280, nil, nil, nil)

var originsListByEndpoint* = Call_OriginsListByEndpoint_575269(
    name: "originsListByEndpoint", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins",
    validator: validate_OriginsListByEndpoint_575270, base: "",
    url: url_OriginsListByEndpoint_575271, schemes: {Scheme.Https})
type
  Call_OriginsGet_575281 = ref object of OpenApiRestCall_574466
proc url_OriginsGet_575283(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_OriginsGet_575282(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing origin within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   originName: JString (required)
  ##             : Name of the origin which is unique within the endpoint.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575284 = path.getOrDefault("resourceGroupName")
  valid_575284 = validateParameter(valid_575284, JString, required = true,
                                 default = nil)
  if valid_575284 != nil:
    section.add "resourceGroupName", valid_575284
  var valid_575285 = path.getOrDefault("originName")
  valid_575285 = validateParameter(valid_575285, JString, required = true,
                                 default = nil)
  if valid_575285 != nil:
    section.add "originName", valid_575285
  var valid_575286 = path.getOrDefault("subscriptionId")
  valid_575286 = validateParameter(valid_575286, JString, required = true,
                                 default = nil)
  if valid_575286 != nil:
    section.add "subscriptionId", valid_575286
  var valid_575287 = path.getOrDefault("profileName")
  valid_575287 = validateParameter(valid_575287, JString, required = true,
                                 default = nil)
  if valid_575287 != nil:
    section.add "profileName", valid_575287
  var valid_575288 = path.getOrDefault("endpointName")
  valid_575288 = validateParameter(valid_575288, JString, required = true,
                                 default = nil)
  if valid_575288 != nil:
    section.add "endpointName", valid_575288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575289 = query.getOrDefault("api-version")
  valid_575289 = validateParameter(valid_575289, JString, required = true,
                                 default = nil)
  if valid_575289 != nil:
    section.add "api-version", valid_575289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575290: Call_OriginsGet_575281; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing origin within an endpoint.
  ## 
  let valid = call_575290.validator(path, query, header, formData, body)
  let scheme = call_575290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575290.url(scheme.get, call_575290.host, call_575290.base,
                         call_575290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575290, url, valid)

proc call*(call_575291: Call_OriginsGet_575281; resourceGroupName: string;
          apiVersion: string; originName: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## originsGet
  ## Gets an existing origin within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   originName: string (required)
  ##             : Name of the origin which is unique within the endpoint.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575292 = newJObject()
  var query_575293 = newJObject()
  add(path_575292, "resourceGroupName", newJString(resourceGroupName))
  add(query_575293, "api-version", newJString(apiVersion))
  add(path_575292, "originName", newJString(originName))
  add(path_575292, "subscriptionId", newJString(subscriptionId))
  add(path_575292, "profileName", newJString(profileName))
  add(path_575292, "endpointName", newJString(endpointName))
  result = call_575291.call(path_575292, query_575293, nil, nil, nil)

var originsGet* = Call_OriginsGet_575281(name: "originsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
                                      validator: validate_OriginsGet_575282,
                                      base: "", url: url_OriginsGet_575283,
                                      schemes: {Scheme.Https})
type
  Call_OriginsUpdate_575294 = ref object of OpenApiRestCall_574466
proc url_OriginsUpdate_575296(protocol: Scheme; host: string; base: string;
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

proc validate_OriginsUpdate_575295(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing origin within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   originName: JString (required)
  ##             : Name of the origin which is unique within the endpoint.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575297 = path.getOrDefault("resourceGroupName")
  valid_575297 = validateParameter(valid_575297, JString, required = true,
                                 default = nil)
  if valid_575297 != nil:
    section.add "resourceGroupName", valid_575297
  var valid_575298 = path.getOrDefault("originName")
  valid_575298 = validateParameter(valid_575298, JString, required = true,
                                 default = nil)
  if valid_575298 != nil:
    section.add "originName", valid_575298
  var valid_575299 = path.getOrDefault("subscriptionId")
  valid_575299 = validateParameter(valid_575299, JString, required = true,
                                 default = nil)
  if valid_575299 != nil:
    section.add "subscriptionId", valid_575299
  var valid_575300 = path.getOrDefault("profileName")
  valid_575300 = validateParameter(valid_575300, JString, required = true,
                                 default = nil)
  if valid_575300 != nil:
    section.add "profileName", valid_575300
  var valid_575301 = path.getOrDefault("endpointName")
  valid_575301 = validateParameter(valid_575301, JString, required = true,
                                 default = nil)
  if valid_575301 != nil:
    section.add "endpointName", valid_575301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575302 = query.getOrDefault("api-version")
  valid_575302 = validateParameter(valid_575302, JString, required = true,
                                 default = nil)
  if valid_575302 != nil:
    section.add "api-version", valid_575302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   originUpdateProperties: JObject (required)
  ##                         : Origin properties
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575304: Call_OriginsUpdate_575294; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing origin within an endpoint.
  ## 
  let valid = call_575304.validator(path, query, header, formData, body)
  let scheme = call_575304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575304.url(scheme.get, call_575304.host, call_575304.base,
                         call_575304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575304, url, valid)

proc call*(call_575305: Call_OriginsUpdate_575294;
          originUpdateProperties: JsonNode; resourceGroupName: string;
          apiVersion: string; originName: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## originsUpdate
  ## Updates an existing origin within an endpoint.
  ##   originUpdateProperties: JObject (required)
  ##                         : Origin properties
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   originName: string (required)
  ##             : Name of the origin which is unique within the endpoint.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575306 = newJObject()
  var query_575307 = newJObject()
  var body_575308 = newJObject()
  if originUpdateProperties != nil:
    body_575308 = originUpdateProperties
  add(path_575306, "resourceGroupName", newJString(resourceGroupName))
  add(query_575307, "api-version", newJString(apiVersion))
  add(path_575306, "originName", newJString(originName))
  add(path_575306, "subscriptionId", newJString(subscriptionId))
  add(path_575306, "profileName", newJString(profileName))
  add(path_575306, "endpointName", newJString(endpointName))
  result = call_575305.call(path_575306, query_575307, nil, nil, body_575308)

var originsUpdate* = Call_OriginsUpdate_575294(name: "originsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
    validator: validate_OriginsUpdate_575295, base: "", url: url_OriginsUpdate_575296,
    schemes: {Scheme.Https})
type
  Call_EndpointsPurgeContent_575309 = ref object of OpenApiRestCall_574466
proc url_EndpointsPurgeContent_575311(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsPurgeContent_575310(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a content from CDN.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575312 = path.getOrDefault("resourceGroupName")
  valid_575312 = validateParameter(valid_575312, JString, required = true,
                                 default = nil)
  if valid_575312 != nil:
    section.add "resourceGroupName", valid_575312
  var valid_575313 = path.getOrDefault("subscriptionId")
  valid_575313 = validateParameter(valid_575313, JString, required = true,
                                 default = nil)
  if valid_575313 != nil:
    section.add "subscriptionId", valid_575313
  var valid_575314 = path.getOrDefault("profileName")
  valid_575314 = validateParameter(valid_575314, JString, required = true,
                                 default = nil)
  if valid_575314 != nil:
    section.add "profileName", valid_575314
  var valid_575315 = path.getOrDefault("endpointName")
  valid_575315 = validateParameter(valid_575315, JString, required = true,
                                 default = nil)
  if valid_575315 != nil:
    section.add "endpointName", valid_575315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575316 = query.getOrDefault("api-version")
  valid_575316 = validateParameter(valid_575316, JString, required = true,
                                 default = nil)
  if valid_575316 != nil:
    section.add "api-version", valid_575316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be purged. Path can be a full URL, e.g. '/pictures/city.png' which removes a single file, or a directory with a wildcard, e.g. '/pictures/*' which removes all folders and files in the directory.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575318: Call_EndpointsPurgeContent_575309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a content from CDN.
  ## 
  let valid = call_575318.validator(path, query, header, formData, body)
  let scheme = call_575318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575318.url(scheme.get, call_575318.host, call_575318.base,
                         call_575318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575318, url, valid)

proc call*(call_575319: Call_EndpointsPurgeContent_575309;
          resourceGroupName: string; contentFilePaths: JsonNode; apiVersion: string;
          subscriptionId: string; profileName: string; endpointName: string): Recallable =
  ## endpointsPurgeContent
  ## Removes a content from CDN.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be purged. Path can be a full URL, e.g. '/pictures/city.png' which removes a single file, or a directory with a wildcard, e.g. '/pictures/*' which removes all folders and files in the directory.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575320 = newJObject()
  var query_575321 = newJObject()
  var body_575322 = newJObject()
  add(path_575320, "resourceGroupName", newJString(resourceGroupName))
  if contentFilePaths != nil:
    body_575322 = contentFilePaths
  add(query_575321, "api-version", newJString(apiVersion))
  add(path_575320, "subscriptionId", newJString(subscriptionId))
  add(path_575320, "profileName", newJString(profileName))
  add(path_575320, "endpointName", newJString(endpointName))
  result = call_575319.call(path_575320, query_575321, nil, nil, body_575322)

var endpointsPurgeContent* = Call_EndpointsPurgeContent_575309(
    name: "endpointsPurgeContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/purge",
    validator: validate_EndpointsPurgeContent_575310, base: "",
    url: url_EndpointsPurgeContent_575311, schemes: {Scheme.Https})
type
  Call_EndpointsStart_575323 = ref object of OpenApiRestCall_574466
proc url_EndpointsStart_575325(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsStart_575324(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Starts an existing CDN endpoint that is on a stopped state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575326 = path.getOrDefault("resourceGroupName")
  valid_575326 = validateParameter(valid_575326, JString, required = true,
                                 default = nil)
  if valid_575326 != nil:
    section.add "resourceGroupName", valid_575326
  var valid_575327 = path.getOrDefault("subscriptionId")
  valid_575327 = validateParameter(valid_575327, JString, required = true,
                                 default = nil)
  if valid_575327 != nil:
    section.add "subscriptionId", valid_575327
  var valid_575328 = path.getOrDefault("profileName")
  valid_575328 = validateParameter(valid_575328, JString, required = true,
                                 default = nil)
  if valid_575328 != nil:
    section.add "profileName", valid_575328
  var valid_575329 = path.getOrDefault("endpointName")
  valid_575329 = validateParameter(valid_575329, JString, required = true,
                                 default = nil)
  if valid_575329 != nil:
    section.add "endpointName", valid_575329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575330 = query.getOrDefault("api-version")
  valid_575330 = validateParameter(valid_575330, JString, required = true,
                                 default = nil)
  if valid_575330 != nil:
    section.add "api-version", valid_575330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575331: Call_EndpointsStart_575323; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an existing CDN endpoint that is on a stopped state.
  ## 
  let valid = call_575331.validator(path, query, header, formData, body)
  let scheme = call_575331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575331.url(scheme.get, call_575331.host, call_575331.base,
                         call_575331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575331, url, valid)

proc call*(call_575332: Call_EndpointsStart_575323; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          endpointName: string): Recallable =
  ## endpointsStart
  ## Starts an existing CDN endpoint that is on a stopped state.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575333 = newJObject()
  var query_575334 = newJObject()
  add(path_575333, "resourceGroupName", newJString(resourceGroupName))
  add(query_575334, "api-version", newJString(apiVersion))
  add(path_575333, "subscriptionId", newJString(subscriptionId))
  add(path_575333, "profileName", newJString(profileName))
  add(path_575333, "endpointName", newJString(endpointName))
  result = call_575332.call(path_575333, query_575334, nil, nil, nil)

var endpointsStart* = Call_EndpointsStart_575323(name: "endpointsStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/start",
    validator: validate_EndpointsStart_575324, base: "", url: url_EndpointsStart_575325,
    schemes: {Scheme.Https})
type
  Call_EndpointsStop_575335 = ref object of OpenApiRestCall_574466
proc url_EndpointsStop_575337(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsStop_575336(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops an existing running CDN endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575338 = path.getOrDefault("resourceGroupName")
  valid_575338 = validateParameter(valid_575338, JString, required = true,
                                 default = nil)
  if valid_575338 != nil:
    section.add "resourceGroupName", valid_575338
  var valid_575339 = path.getOrDefault("subscriptionId")
  valid_575339 = validateParameter(valid_575339, JString, required = true,
                                 default = nil)
  if valid_575339 != nil:
    section.add "subscriptionId", valid_575339
  var valid_575340 = path.getOrDefault("profileName")
  valid_575340 = validateParameter(valid_575340, JString, required = true,
                                 default = nil)
  if valid_575340 != nil:
    section.add "profileName", valid_575340
  var valid_575341 = path.getOrDefault("endpointName")
  valid_575341 = validateParameter(valid_575341, JString, required = true,
                                 default = nil)
  if valid_575341 != nil:
    section.add "endpointName", valid_575341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575342 = query.getOrDefault("api-version")
  valid_575342 = validateParameter(valid_575342, JString, required = true,
                                 default = nil)
  if valid_575342 != nil:
    section.add "api-version", valid_575342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575343: Call_EndpointsStop_575335; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an existing running CDN endpoint.
  ## 
  let valid = call_575343.validator(path, query, header, formData, body)
  let scheme = call_575343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575343.url(scheme.get, call_575343.host, call_575343.base,
                         call_575343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575343, url, valid)

proc call*(call_575344: Call_EndpointsStop_575335; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          endpointName: string): Recallable =
  ## endpointsStop
  ## Stops an existing running CDN endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575345 = newJObject()
  var query_575346 = newJObject()
  add(path_575345, "resourceGroupName", newJString(resourceGroupName))
  add(query_575346, "api-version", newJString(apiVersion))
  add(path_575345, "subscriptionId", newJString(subscriptionId))
  add(path_575345, "profileName", newJString(profileName))
  add(path_575345, "endpointName", newJString(endpointName))
  result = call_575344.call(path_575345, query_575346, nil, nil, nil)

var endpointsStop* = Call_EndpointsStop_575335(name: "endpointsStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/stop",
    validator: validate_EndpointsStop_575336, base: "", url: url_EndpointsStop_575337,
    schemes: {Scheme.Https})
type
  Call_EndpointsValidateCustomDomain_575347 = ref object of OpenApiRestCall_574466
proc url_EndpointsValidateCustomDomain_575349(protocol: Scheme; host: string;
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

proc validate_EndpointsValidateCustomDomain_575348(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the custom domain mapping to ensure it maps to the correct CDN endpoint in DNS.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575350 = path.getOrDefault("resourceGroupName")
  valid_575350 = validateParameter(valid_575350, JString, required = true,
                                 default = nil)
  if valid_575350 != nil:
    section.add "resourceGroupName", valid_575350
  var valid_575351 = path.getOrDefault("subscriptionId")
  valid_575351 = validateParameter(valid_575351, JString, required = true,
                                 default = nil)
  if valid_575351 != nil:
    section.add "subscriptionId", valid_575351
  var valid_575352 = path.getOrDefault("profileName")
  valid_575352 = validateParameter(valid_575352, JString, required = true,
                                 default = nil)
  if valid_575352 != nil:
    section.add "profileName", valid_575352
  var valid_575353 = path.getOrDefault("endpointName")
  valid_575353 = validateParameter(valid_575353, JString, required = true,
                                 default = nil)
  if valid_575353 != nil:
    section.add "endpointName", valid_575353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575354 = query.getOrDefault("api-version")
  valid_575354 = validateParameter(valid_575354, JString, required = true,
                                 default = nil)
  if valid_575354 != nil:
    section.add "api-version", valid_575354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain to be validated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575356: Call_EndpointsValidateCustomDomain_575347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the custom domain mapping to ensure it maps to the correct CDN endpoint in DNS.
  ## 
  let valid = call_575356.validator(path, query, header, formData, body)
  let scheme = call_575356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575356.url(scheme.get, call_575356.host, call_575356.base,
                         call_575356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575356, url, valid)

proc call*(call_575357: Call_EndpointsValidateCustomDomain_575347;
          resourceGroupName: string; apiVersion: string;
          customDomainProperties: JsonNode; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## endpointsValidateCustomDomain
  ## Validates the custom domain mapping to ensure it maps to the correct CDN endpoint in DNS.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain to be validated.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575358 = newJObject()
  var query_575359 = newJObject()
  var body_575360 = newJObject()
  add(path_575358, "resourceGroupName", newJString(resourceGroupName))
  add(query_575359, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_575360 = customDomainProperties
  add(path_575358, "subscriptionId", newJString(subscriptionId))
  add(path_575358, "profileName", newJString(profileName))
  add(path_575358, "endpointName", newJString(endpointName))
  result = call_575357.call(path_575358, query_575359, nil, nil, body_575360)

var endpointsValidateCustomDomain* = Call_EndpointsValidateCustomDomain_575347(
    name: "endpointsValidateCustomDomain", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/validateCustomDomain",
    validator: validate_EndpointsValidateCustomDomain_575348, base: "",
    url: url_EndpointsValidateCustomDomain_575349, schemes: {Scheme.Https})
type
  Call_ProfilesGenerateSsoUri_575361 = ref object of OpenApiRestCall_574466
proc url_ProfilesGenerateSsoUri_575363(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesGenerateSsoUri_575362(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates a dynamic SSO URI used to sign in to the CDN supplemental portal. Supplemental portal is used to configure advanced feature capabilities that are not yet available in the Azure portal, such as core reports in a standard profile; rules engine, advanced HTTP reports, and real-time stats and alerts in a premium profile. The SSO URI changes approximately every 10 minutes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575364 = path.getOrDefault("resourceGroupName")
  valid_575364 = validateParameter(valid_575364, JString, required = true,
                                 default = nil)
  if valid_575364 != nil:
    section.add "resourceGroupName", valid_575364
  var valid_575365 = path.getOrDefault("subscriptionId")
  valid_575365 = validateParameter(valid_575365, JString, required = true,
                                 default = nil)
  if valid_575365 != nil:
    section.add "subscriptionId", valid_575365
  var valid_575366 = path.getOrDefault("profileName")
  valid_575366 = validateParameter(valid_575366, JString, required = true,
                                 default = nil)
  if valid_575366 != nil:
    section.add "profileName", valid_575366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575367 = query.getOrDefault("api-version")
  valid_575367 = validateParameter(valid_575367, JString, required = true,
                                 default = nil)
  if valid_575367 != nil:
    section.add "api-version", valid_575367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575368: Call_ProfilesGenerateSsoUri_575361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a dynamic SSO URI used to sign in to the CDN supplemental portal. Supplemental portal is used to configure advanced feature capabilities that are not yet available in the Azure portal, such as core reports in a standard profile; rules engine, advanced HTTP reports, and real-time stats and alerts in a premium profile. The SSO URI changes approximately every 10 minutes.
  ## 
  let valid = call_575368.validator(path, query, header, formData, body)
  let scheme = call_575368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575368.url(scheme.get, call_575368.host, call_575368.base,
                         call_575368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575368, url, valid)

proc call*(call_575369: Call_ProfilesGenerateSsoUri_575361;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string): Recallable =
  ## profilesGenerateSsoUri
  ## Generates a dynamic SSO URI used to sign in to the CDN supplemental portal. Supplemental portal is used to configure advanced feature capabilities that are not yet available in the Azure portal, such as core reports in a standard profile; rules engine, advanced HTTP reports, and real-time stats and alerts in a premium profile. The SSO URI changes approximately every 10 minutes.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_575370 = newJObject()
  var query_575371 = newJObject()
  add(path_575370, "resourceGroupName", newJString(resourceGroupName))
  add(query_575371, "api-version", newJString(apiVersion))
  add(path_575370, "subscriptionId", newJString(subscriptionId))
  add(path_575370, "profileName", newJString(profileName))
  result = call_575369.call(path_575370, query_575371, nil, nil, nil)

var profilesGenerateSsoUri* = Call_ProfilesGenerateSsoUri_575361(
    name: "profilesGenerateSsoUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/generateSsoUri",
    validator: validate_ProfilesGenerateSsoUri_575362, base: "",
    url: url_ProfilesGenerateSsoUri_575363, schemes: {Scheme.Https})
type
  Call_ProfilesGetSupportedOptimizationTypes_575372 = ref object of OpenApiRestCall_574466
proc url_ProfilesGetSupportedOptimizationTypes_575374(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/getSupportedOptimizationTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesGetSupportedOptimizationTypes_575373(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the supported optimization types for the current profile. A user can create an endpoint with an optimization type from the listed values.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575375 = path.getOrDefault("resourceGroupName")
  valid_575375 = validateParameter(valid_575375, JString, required = true,
                                 default = nil)
  if valid_575375 != nil:
    section.add "resourceGroupName", valid_575375
  var valid_575376 = path.getOrDefault("subscriptionId")
  valid_575376 = validateParameter(valid_575376, JString, required = true,
                                 default = nil)
  if valid_575376 != nil:
    section.add "subscriptionId", valid_575376
  var valid_575377 = path.getOrDefault("profileName")
  valid_575377 = validateParameter(valid_575377, JString, required = true,
                                 default = nil)
  if valid_575377 != nil:
    section.add "profileName", valid_575377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-10-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575378 = query.getOrDefault("api-version")
  valid_575378 = validateParameter(valid_575378, JString, required = true,
                                 default = nil)
  if valid_575378 != nil:
    section.add "api-version", valid_575378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575379: Call_ProfilesGetSupportedOptimizationTypes_575372;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the supported optimization types for the current profile. A user can create an endpoint with an optimization type from the listed values.
  ## 
  let valid = call_575379.validator(path, query, header, formData, body)
  let scheme = call_575379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575379.url(scheme.get, call_575379.host, call_575379.base,
                         call_575379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575379, url, valid)

proc call*(call_575380: Call_ProfilesGetSupportedOptimizationTypes_575372;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string): Recallable =
  ## profilesGetSupportedOptimizationTypes
  ## Gets the supported optimization types for the current profile. A user can create an endpoint with an optimization type from the listed values.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-10-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_575381 = newJObject()
  var query_575382 = newJObject()
  add(path_575381, "resourceGroupName", newJString(resourceGroupName))
  add(query_575382, "api-version", newJString(apiVersion))
  add(path_575381, "subscriptionId", newJString(subscriptionId))
  add(path_575381, "profileName", newJString(profileName))
  result = call_575380.call(path_575381, query_575382, nil, nil, nil)

var profilesGetSupportedOptimizationTypes* = Call_ProfilesGetSupportedOptimizationTypes_575372(
    name: "profilesGetSupportedOptimizationTypes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/getSupportedOptimizationTypes",
    validator: validate_ProfilesGetSupportedOptimizationTypes_575373, base: "",
    url: url_ProfilesGetSupportedOptimizationTypes_575374, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
