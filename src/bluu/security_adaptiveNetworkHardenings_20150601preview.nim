
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2015-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## API spec for Microsoft.Security (Azure Security Center) resource provider
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  macServiceName = "security-adaptiveNetworkHardenings"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdaptiveNetworkHardeningsListByExtendedResource_593646 = ref object of OpenApiRestCall_593424
proc url_AdaptiveNetworkHardeningsListByExtendedResource_593648(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/adaptiveNetworkHardenings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdaptiveNetworkHardeningsListByExtendedResource_593647(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a list of Adaptive Network Hardenings resources in scope of an extended resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_593808 = path.getOrDefault("resourceType")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "resourceType", valid_593808
  var valid_593809 = path.getOrDefault("resourceGroupName")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "resourceGroupName", valid_593809
  var valid_593810 = path.getOrDefault("subscriptionId")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "subscriptionId", valid_593810
  var valid_593811 = path.getOrDefault("resourceName")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "resourceName", valid_593811
  var valid_593812 = path.getOrDefault("resourceNamespace")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "resourceNamespace", valid_593812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593813 = query.getOrDefault("api-version")
  valid_593813 = validateParameter(valid_593813, JString, required = true,
                                 default = nil)
  if valid_593813 != nil:
    section.add "api-version", valid_593813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593840: Call_AdaptiveNetworkHardeningsListByExtendedResource_593646;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of Adaptive Network Hardenings resources in scope of an extended resource.
  ## 
  let valid = call_593840.validator(path, query, header, formData, body)
  let scheme = call_593840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593840.url(scheme.get, call_593840.host, call_593840.base,
                         call_593840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593840, url, valid)

proc call*(call_593911: Call_AdaptiveNetworkHardeningsListByExtendedResource_593646;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; resourceNamespace: string): Recallable =
  ## adaptiveNetworkHardeningsListByExtendedResource
  ## Gets a list of Adaptive Network Hardenings resources in scope of an extended resource.
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  var path_593912 = newJObject()
  var query_593914 = newJObject()
  add(path_593912, "resourceType", newJString(resourceType))
  add(path_593912, "resourceGroupName", newJString(resourceGroupName))
  add(query_593914, "api-version", newJString(apiVersion))
  add(path_593912, "subscriptionId", newJString(subscriptionId))
  add(path_593912, "resourceName", newJString(resourceName))
  add(path_593912, "resourceNamespace", newJString(resourceNamespace))
  result = call_593911.call(path_593912, query_593914, nil, nil, nil)

var adaptiveNetworkHardeningsListByExtendedResource* = Call_AdaptiveNetworkHardeningsListByExtendedResource_593646(
    name: "adaptiveNetworkHardeningsListByExtendedResource",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.Security/adaptiveNetworkHardenings",
    validator: validate_AdaptiveNetworkHardeningsListByExtendedResource_593647,
    base: "", url: url_AdaptiveNetworkHardeningsListByExtendedResource_593648,
    schemes: {Scheme.Https})
type
  Call_AdaptiveNetworkHardeningsGet_593953 = ref object of OpenApiRestCall_593424
proc url_AdaptiveNetworkHardeningsGet_593955(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "adaptiveNetworkHardeningResourceName" in path,
        "`adaptiveNetworkHardeningResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/adaptiveNetworkHardenings/"), (
        kind: VariableSegment, value: "adaptiveNetworkHardeningResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdaptiveNetworkHardeningsGet_593954(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a single Adaptive Network Hardening resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   adaptiveNetworkHardeningResourceName: JString (required)
  ##                                       : The name of the Adaptive Network Hardening resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_593965 = path.getOrDefault("resourceType")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "resourceType", valid_593965
  var valid_593966 = path.getOrDefault("resourceGroupName")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "resourceGroupName", valid_593966
  var valid_593967 = path.getOrDefault("subscriptionId")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "subscriptionId", valid_593967
  var valid_593968 = path.getOrDefault("resourceName")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "resourceName", valid_593968
  var valid_593969 = path.getOrDefault("resourceNamespace")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "resourceNamespace", valid_593969
  var valid_593970 = path.getOrDefault("adaptiveNetworkHardeningResourceName")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "adaptiveNetworkHardeningResourceName", valid_593970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593971 = query.getOrDefault("api-version")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "api-version", valid_593971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593972: Call_AdaptiveNetworkHardeningsGet_593953; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a single Adaptive Network Hardening resource
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_AdaptiveNetworkHardeningsGet_593953;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; resourceNamespace: string;
          adaptiveNetworkHardeningResourceName: string): Recallable =
  ## adaptiveNetworkHardeningsGet
  ## Gets a single Adaptive Network Hardening resource
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   adaptiveNetworkHardeningResourceName: string (required)
  ##                                       : The name of the Adaptive Network Hardening resource.
  var path_593974 = newJObject()
  var query_593975 = newJObject()
  add(path_593974, "resourceType", newJString(resourceType))
  add(path_593974, "resourceGroupName", newJString(resourceGroupName))
  add(query_593975, "api-version", newJString(apiVersion))
  add(path_593974, "subscriptionId", newJString(subscriptionId))
  add(path_593974, "resourceName", newJString(resourceName))
  add(path_593974, "resourceNamespace", newJString(resourceNamespace))
  add(path_593974, "adaptiveNetworkHardeningResourceName",
      newJString(adaptiveNetworkHardeningResourceName))
  result = call_593973.call(path_593974, query_593975, nil, nil, nil)

var adaptiveNetworkHardeningsGet* = Call_AdaptiveNetworkHardeningsGet_593953(
    name: "adaptiveNetworkHardeningsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.Security/adaptiveNetworkHardenings/{adaptiveNetworkHardeningResourceName}",
    validator: validate_AdaptiveNetworkHardeningsGet_593954, base: "",
    url: url_AdaptiveNetworkHardeningsGet_593955, schemes: {Scheme.Https})
type
  Call_AdaptiveNetworkHardeningsEnforce_593976 = ref object of OpenApiRestCall_593424
proc url_AdaptiveNetworkHardeningsEnforce_593978(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "adaptiveNetworkHardeningResourceName" in path,
        "`adaptiveNetworkHardeningResourceName` is a required path parameter"
  assert "adaptiveNetworkHardeningEnforceAction" in path,
        "`adaptiveNetworkHardeningEnforceAction` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/adaptiveNetworkHardenings/"), (
        kind: VariableSegment, value: "adaptiveNetworkHardeningResourceName"),
               (kind: ConstantSegment, value: "/"), (kind: VariableSegment,
        value: "adaptiveNetworkHardeningEnforceAction")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdaptiveNetworkHardeningsEnforce_593977(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enforces the given rules on the NSG(s) listed in the request
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   adaptiveNetworkHardeningEnforceAction: JString (required)
  ##                                        : Enforces the given rules on the NSG(s) listed in the request
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   adaptiveNetworkHardeningResourceName: JString (required)
  ##                                       : The name of the Adaptive Network Hardening resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_593979 = path.getOrDefault("resourceType")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "resourceType", valid_593979
  var valid_593980 = path.getOrDefault("resourceGroupName")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "resourceGroupName", valid_593980
  var valid_593981 = path.getOrDefault("subscriptionId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "subscriptionId", valid_593981
  var valid_593982 = path.getOrDefault("resourceName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "resourceName", valid_593982
  var valid_593996 = path.getOrDefault("adaptiveNetworkHardeningEnforceAction")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = newJString("enforce"))
  if valid_593996 != nil:
    section.add "adaptiveNetworkHardeningEnforceAction", valid_593996
  var valid_593997 = path.getOrDefault("resourceNamespace")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "resourceNamespace", valid_593997
  var valid_593998 = path.getOrDefault("adaptiveNetworkHardeningResourceName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "adaptiveNetworkHardeningResourceName", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593999 = query.getOrDefault("api-version")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "api-version", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594001: Call_AdaptiveNetworkHardeningsEnforce_593976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enforces the given rules on the NSG(s) listed in the request
  ## 
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_AdaptiveNetworkHardeningsEnforce_593976;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; resourceNamespace: string;
          adaptiveNetworkHardeningResourceName: string; body: JsonNode;
          adaptiveNetworkHardeningEnforceAction: string = "enforce"): Recallable =
  ## adaptiveNetworkHardeningsEnforce
  ## Enforces the given rules on the NSG(s) listed in the request
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   adaptiveNetworkHardeningEnforceAction: string (required)
  ##                                        : Enforces the given rules on the NSG(s) listed in the request
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   adaptiveNetworkHardeningResourceName: string (required)
  ##                                       : The name of the Adaptive Network Hardening resource.
  ##   body: JObject (required)
  var path_594003 = newJObject()
  var query_594004 = newJObject()
  var body_594005 = newJObject()
  add(path_594003, "resourceType", newJString(resourceType))
  add(path_594003, "resourceGroupName", newJString(resourceGroupName))
  add(query_594004, "api-version", newJString(apiVersion))
  add(path_594003, "subscriptionId", newJString(subscriptionId))
  add(path_594003, "resourceName", newJString(resourceName))
  add(path_594003, "adaptiveNetworkHardeningEnforceAction",
      newJString(adaptiveNetworkHardeningEnforceAction))
  add(path_594003, "resourceNamespace", newJString(resourceNamespace))
  add(path_594003, "adaptiveNetworkHardeningResourceName",
      newJString(adaptiveNetworkHardeningResourceName))
  if body != nil:
    body_594005 = body
  result = call_594002.call(path_594003, query_594004, nil, nil, body_594005)

var adaptiveNetworkHardeningsEnforce* = Call_AdaptiveNetworkHardeningsEnforce_593976(
    name: "adaptiveNetworkHardeningsEnforce", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.Security/adaptiveNetworkHardenings/{adaptiveNetworkHardeningResourceName}/{adaptiveNetworkHardeningEnforceAction}",
    validator: validate_AdaptiveNetworkHardeningsEnforce_593977, base: "",
    url: url_AdaptiveNetworkHardeningsEnforce_593978, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
