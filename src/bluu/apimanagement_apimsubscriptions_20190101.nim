
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2019-01-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Subscription entity associated with your Azure API Management deployment. The Subscription entity represents the association between a user and a product in API Management. Products contain one or more APIs, and once a product is published, developers can subscribe to the product and begin to use the product’s APIs.
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

  OpenApiRestCall_596457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596457): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimsubscriptions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SubscriptionList_596679 = ref object of OpenApiRestCall_596457
proc url_SubscriptionList_596681(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionList_596680(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all subscriptions of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596842 = path.getOrDefault("resourceGroupName")
  valid_596842 = validateParameter(valid_596842, JString, required = true,
                                 default = nil)
  if valid_596842 != nil:
    section.add "resourceGroupName", valid_596842
  var valid_596843 = path.getOrDefault("subscriptionId")
  valid_596843 = validateParameter(valid_596843, JString, required = true,
                                 default = nil)
  if valid_596843 != nil:
    section.add "subscriptionId", valid_596843
  var valid_596844 = path.getOrDefault("serviceName")
  valid_596844 = validateParameter(valid_596844, JString, required = true,
                                 default = nil)
  if valid_596844 != nil:
    section.add "serviceName", valid_596844
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| stateComment | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| ownerId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| scope | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| userId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| productId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| state | filter | eq |     | </br>| user | expand |     |     | </br>
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596845 = query.getOrDefault("api-version")
  valid_596845 = validateParameter(valid_596845, JString, required = true,
                                 default = nil)
  if valid_596845 != nil:
    section.add "api-version", valid_596845
  var valid_596846 = query.getOrDefault("$top")
  valid_596846 = validateParameter(valid_596846, JInt, required = false, default = nil)
  if valid_596846 != nil:
    section.add "$top", valid_596846
  var valid_596847 = query.getOrDefault("$skip")
  valid_596847 = validateParameter(valid_596847, JInt, required = false, default = nil)
  if valid_596847 != nil:
    section.add "$skip", valid_596847
  var valid_596848 = query.getOrDefault("$filter")
  valid_596848 = validateParameter(valid_596848, JString, required = false,
                                 default = nil)
  if valid_596848 != nil:
    section.add "$filter", valid_596848
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596875: Call_SubscriptionList_596679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all subscriptions of the API Management service instance.
  ## 
  let valid = call_596875.validator(path, query, header, formData, body)
  let scheme = call_596875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596875.url(scheme.get, call_596875.host, call_596875.base,
                         call_596875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596875, url, valid)

proc call*(call_596946: Call_SubscriptionList_596679; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## subscriptionList
  ## Lists all subscriptions of the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| stateComment | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| ownerId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| scope | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| userId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| productId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| state | filter | eq |     | </br>| user | expand |     |     | </br>
  var path_596947 = newJObject()
  var query_596949 = newJObject()
  add(path_596947, "resourceGroupName", newJString(resourceGroupName))
  add(query_596949, "api-version", newJString(apiVersion))
  add(path_596947, "subscriptionId", newJString(subscriptionId))
  add(query_596949, "$top", newJInt(Top))
  add(query_596949, "$skip", newJInt(Skip))
  add(path_596947, "serviceName", newJString(serviceName))
  add(query_596949, "$filter", newJString(Filter))
  result = call_596946.call(path_596947, query_596949, nil, nil, nil)

var subscriptionList* = Call_SubscriptionList_596679(name: "subscriptionList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions",
    validator: validate_SubscriptionList_596680, base: "",
    url: url_SubscriptionList_596681, schemes: {Scheme.Https})
type
  Call_SubscriptionCreateOrUpdate_597000 = ref object of OpenApiRestCall_596457
proc url_SubscriptionCreateOrUpdate_597002(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionCreateOrUpdate_597001(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the subscription of specified user to the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: JString (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597030 = path.getOrDefault("resourceGroupName")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "resourceGroupName", valid_597030
  var valid_597031 = path.getOrDefault("subscriptionId")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "subscriptionId", valid_597031
  var valid_597032 = path.getOrDefault("sid")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "sid", valid_597032
  var valid_597033 = path.getOrDefault("serviceName")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "serviceName", valid_597033
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   notify: JBool
  ##         : Notify change in Subscription State. 
  ##  - If false, do not send any email notification for change of state of subscription 
  ##  - If true, send email notification of change of state of subscription 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597034 = query.getOrDefault("api-version")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "api-version", valid_597034
  var valid_597035 = query.getOrDefault("notify")
  valid_597035 = validateParameter(valid_597035, JBool, required = false, default = nil)
  if valid_597035 != nil:
    section.add "notify", valid_597035
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_597036 = header.getOrDefault("If-Match")
  valid_597036 = validateParameter(valid_597036, JString, required = false,
                                 default = nil)
  if valid_597036 != nil:
    section.add "If-Match", valid_597036
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597038: Call_SubscriptionCreateOrUpdate_597000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the subscription of specified user to the specified product.
  ## 
  let valid = call_597038.validator(path, query, header, formData, body)
  let scheme = call_597038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597038.url(scheme.get, call_597038.host, call_597038.base,
                         call_597038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597038, url, valid)

proc call*(call_597039: Call_SubscriptionCreateOrUpdate_597000;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; sid: string; serviceName: string; notify: bool = false): Recallable =
  ## subscriptionCreateOrUpdate
  ## Creates or updates the subscription of specified user to the specified product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   notify: bool
  ##         : Notify change in Subscription State. 
  ##  - If false, do not send any email notification for change of state of subscription 
  ##  - If true, send email notification of change of state of subscription 
  var path_597040 = newJObject()
  var query_597041 = newJObject()
  var body_597042 = newJObject()
  add(path_597040, "resourceGroupName", newJString(resourceGroupName))
  add(query_597041, "api-version", newJString(apiVersion))
  add(path_597040, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597042 = parameters
  add(path_597040, "sid", newJString(sid))
  add(path_597040, "serviceName", newJString(serviceName))
  add(query_597041, "notify", newJBool(notify))
  result = call_597039.call(path_597040, query_597041, nil, nil, body_597042)

var subscriptionCreateOrUpdate* = Call_SubscriptionCreateOrUpdate_597000(
    name: "subscriptionCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions/{sid}",
    validator: validate_SubscriptionCreateOrUpdate_597001, base: "",
    url: url_SubscriptionCreateOrUpdate_597002, schemes: {Scheme.Https})
type
  Call_SubscriptionGetEntityTag_597056 = ref object of OpenApiRestCall_596457
proc url_SubscriptionGetEntityTag_597058(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionGetEntityTag_597057(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the apimanagement subscription specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: JString (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597059 = path.getOrDefault("resourceGroupName")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = nil)
  if valid_597059 != nil:
    section.add "resourceGroupName", valid_597059
  var valid_597060 = path.getOrDefault("subscriptionId")
  valid_597060 = validateParameter(valid_597060, JString, required = true,
                                 default = nil)
  if valid_597060 != nil:
    section.add "subscriptionId", valid_597060
  var valid_597061 = path.getOrDefault("sid")
  valid_597061 = validateParameter(valid_597061, JString, required = true,
                                 default = nil)
  if valid_597061 != nil:
    section.add "sid", valid_597061
  var valid_597062 = path.getOrDefault("serviceName")
  valid_597062 = validateParameter(valid_597062, JString, required = true,
                                 default = nil)
  if valid_597062 != nil:
    section.add "serviceName", valid_597062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597063 = query.getOrDefault("api-version")
  valid_597063 = validateParameter(valid_597063, JString, required = true,
                                 default = nil)
  if valid_597063 != nil:
    section.add "api-version", valid_597063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597064: Call_SubscriptionGetEntityTag_597056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the apimanagement subscription specified by its identifier.
  ## 
  let valid = call_597064.validator(path, query, header, formData, body)
  let scheme = call_597064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597064.url(scheme.get, call_597064.host, call_597064.base,
                         call_597064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597064, url, valid)

proc call*(call_597065: Call_SubscriptionGetEntityTag_597056;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          sid: string; serviceName: string): Recallable =
  ## subscriptionGetEntityTag
  ## Gets the entity state (Etag) version of the apimanagement subscription specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597066 = newJObject()
  var query_597067 = newJObject()
  add(path_597066, "resourceGroupName", newJString(resourceGroupName))
  add(query_597067, "api-version", newJString(apiVersion))
  add(path_597066, "subscriptionId", newJString(subscriptionId))
  add(path_597066, "sid", newJString(sid))
  add(path_597066, "serviceName", newJString(serviceName))
  result = call_597065.call(path_597066, query_597067, nil, nil, nil)

var subscriptionGetEntityTag* = Call_SubscriptionGetEntityTag_597056(
    name: "subscriptionGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions/{sid}",
    validator: validate_SubscriptionGetEntityTag_597057, base: "",
    url: url_SubscriptionGetEntityTag_597058, schemes: {Scheme.Https})
type
  Call_SubscriptionGet_596988 = ref object of OpenApiRestCall_596457
proc url_SubscriptionGet_596990(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionGet_596989(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the specified Subscription entity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: JString (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596991 = path.getOrDefault("resourceGroupName")
  valid_596991 = validateParameter(valid_596991, JString, required = true,
                                 default = nil)
  if valid_596991 != nil:
    section.add "resourceGroupName", valid_596991
  var valid_596992 = path.getOrDefault("subscriptionId")
  valid_596992 = validateParameter(valid_596992, JString, required = true,
                                 default = nil)
  if valid_596992 != nil:
    section.add "subscriptionId", valid_596992
  var valid_596993 = path.getOrDefault("sid")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "sid", valid_596993
  var valid_596994 = path.getOrDefault("serviceName")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "serviceName", valid_596994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596995 = query.getOrDefault("api-version")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "api-version", valid_596995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596996: Call_SubscriptionGet_596988; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Subscription entity.
  ## 
  let valid = call_596996.validator(path, query, header, formData, body)
  let scheme = call_596996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596996.url(scheme.get, call_596996.host, call_596996.base,
                         call_596996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596996, url, valid)

proc call*(call_596997: Call_SubscriptionGet_596988; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; sid: string; serviceName: string): Recallable =
  ## subscriptionGet
  ## Gets the specified Subscription entity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_596998 = newJObject()
  var query_596999 = newJObject()
  add(path_596998, "resourceGroupName", newJString(resourceGroupName))
  add(query_596999, "api-version", newJString(apiVersion))
  add(path_596998, "subscriptionId", newJString(subscriptionId))
  add(path_596998, "sid", newJString(sid))
  add(path_596998, "serviceName", newJString(serviceName))
  result = call_596997.call(path_596998, query_596999, nil, nil, nil)

var subscriptionGet* = Call_SubscriptionGet_596988(name: "subscriptionGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions/{sid}",
    validator: validate_SubscriptionGet_596989, base: "", url: url_SubscriptionGet_596990,
    schemes: {Scheme.Https})
type
  Call_SubscriptionUpdate_597068 = ref object of OpenApiRestCall_596457
proc url_SubscriptionUpdate_597070(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionUpdate_597069(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the details of a subscription specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: JString (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597071 = path.getOrDefault("resourceGroupName")
  valid_597071 = validateParameter(valid_597071, JString, required = true,
                                 default = nil)
  if valid_597071 != nil:
    section.add "resourceGroupName", valid_597071
  var valid_597072 = path.getOrDefault("subscriptionId")
  valid_597072 = validateParameter(valid_597072, JString, required = true,
                                 default = nil)
  if valid_597072 != nil:
    section.add "subscriptionId", valid_597072
  var valid_597073 = path.getOrDefault("sid")
  valid_597073 = validateParameter(valid_597073, JString, required = true,
                                 default = nil)
  if valid_597073 != nil:
    section.add "sid", valid_597073
  var valid_597074 = path.getOrDefault("serviceName")
  valid_597074 = validateParameter(valid_597074, JString, required = true,
                                 default = nil)
  if valid_597074 != nil:
    section.add "serviceName", valid_597074
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   notify: JBool
  ##         : Notify change in Subscription State. 
  ##  - If false, do not send any email notification for change of state of subscription 
  ##  - If true, send email notification of change of state of subscription 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597075 = query.getOrDefault("api-version")
  valid_597075 = validateParameter(valid_597075, JString, required = true,
                                 default = nil)
  if valid_597075 != nil:
    section.add "api-version", valid_597075
  var valid_597076 = query.getOrDefault("notify")
  valid_597076 = validateParameter(valid_597076, JBool, required = false, default = nil)
  if valid_597076 != nil:
    section.add "notify", valid_597076
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597077 = header.getOrDefault("If-Match")
  valid_597077 = validateParameter(valid_597077, JString, required = true,
                                 default = nil)
  if valid_597077 != nil:
    section.add "If-Match", valid_597077
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597079: Call_SubscriptionUpdate_597068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of a subscription specified by its identifier.
  ## 
  let valid = call_597079.validator(path, query, header, formData, body)
  let scheme = call_597079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597079.url(scheme.get, call_597079.host, call_597079.base,
                         call_597079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597079, url, valid)

proc call*(call_597080: Call_SubscriptionUpdate_597068; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          sid: string; serviceName: string; notify: bool = false): Recallable =
  ## subscriptionUpdate
  ## Updates the details of a subscription specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   notify: bool
  ##         : Notify change in Subscription State. 
  ##  - If false, do not send any email notification for change of state of subscription 
  ##  - If true, send email notification of change of state of subscription 
  var path_597081 = newJObject()
  var query_597082 = newJObject()
  var body_597083 = newJObject()
  add(path_597081, "resourceGroupName", newJString(resourceGroupName))
  add(query_597082, "api-version", newJString(apiVersion))
  add(path_597081, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597083 = parameters
  add(path_597081, "sid", newJString(sid))
  add(path_597081, "serviceName", newJString(serviceName))
  add(query_597082, "notify", newJBool(notify))
  result = call_597080.call(path_597081, query_597082, nil, nil, body_597083)

var subscriptionUpdate* = Call_SubscriptionUpdate_597068(
    name: "subscriptionUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions/{sid}",
    validator: validate_SubscriptionUpdate_597069, base: "",
    url: url_SubscriptionUpdate_597070, schemes: {Scheme.Https})
type
  Call_SubscriptionDelete_597043 = ref object of OpenApiRestCall_596457
proc url_SubscriptionDelete_597045(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionDelete_597044(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: JString (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597046 = path.getOrDefault("resourceGroupName")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "resourceGroupName", valid_597046
  var valid_597047 = path.getOrDefault("subscriptionId")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "subscriptionId", valid_597047
  var valid_597048 = path.getOrDefault("sid")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "sid", valid_597048
  var valid_597049 = path.getOrDefault("serviceName")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "serviceName", valid_597049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597050 = query.getOrDefault("api-version")
  valid_597050 = validateParameter(valid_597050, JString, required = true,
                                 default = nil)
  if valid_597050 != nil:
    section.add "api-version", valid_597050
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597051 = header.getOrDefault("If-Match")
  valid_597051 = validateParameter(valid_597051, JString, required = true,
                                 default = nil)
  if valid_597051 != nil:
    section.add "If-Match", valid_597051
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597052: Call_SubscriptionDelete_597043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified subscription.
  ## 
  let valid = call_597052.validator(path, query, header, formData, body)
  let scheme = call_597052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597052.url(scheme.get, call_597052.host, call_597052.base,
                         call_597052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597052, url, valid)

proc call*(call_597053: Call_SubscriptionDelete_597043; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; sid: string; serviceName: string): Recallable =
  ## subscriptionDelete
  ## Deletes the specified subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597054 = newJObject()
  var query_597055 = newJObject()
  add(path_597054, "resourceGroupName", newJString(resourceGroupName))
  add(query_597055, "api-version", newJString(apiVersion))
  add(path_597054, "subscriptionId", newJString(subscriptionId))
  add(path_597054, "sid", newJString(sid))
  add(path_597054, "serviceName", newJString(serviceName))
  result = call_597053.call(path_597054, query_597055, nil, nil, nil)

var subscriptionDelete* = Call_SubscriptionDelete_597043(
    name: "subscriptionDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions/{sid}",
    validator: validate_SubscriptionDelete_597044, base: "",
    url: url_SubscriptionDelete_597045, schemes: {Scheme.Https})
type
  Call_SubscriptionRegeneratePrimaryKey_597084 = ref object of OpenApiRestCall_596457
proc url_SubscriptionRegeneratePrimaryKey_597086(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid"),
               (kind: ConstantSegment, value: "/regeneratePrimaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionRegeneratePrimaryKey_597085(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates primary key of existing subscription of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: JString (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597087 = path.getOrDefault("resourceGroupName")
  valid_597087 = validateParameter(valid_597087, JString, required = true,
                                 default = nil)
  if valid_597087 != nil:
    section.add "resourceGroupName", valid_597087
  var valid_597088 = path.getOrDefault("subscriptionId")
  valid_597088 = validateParameter(valid_597088, JString, required = true,
                                 default = nil)
  if valid_597088 != nil:
    section.add "subscriptionId", valid_597088
  var valid_597089 = path.getOrDefault("sid")
  valid_597089 = validateParameter(valid_597089, JString, required = true,
                                 default = nil)
  if valid_597089 != nil:
    section.add "sid", valid_597089
  var valid_597090 = path.getOrDefault("serviceName")
  valid_597090 = validateParameter(valid_597090, JString, required = true,
                                 default = nil)
  if valid_597090 != nil:
    section.add "serviceName", valid_597090
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597091 = query.getOrDefault("api-version")
  valid_597091 = validateParameter(valid_597091, JString, required = true,
                                 default = nil)
  if valid_597091 != nil:
    section.add "api-version", valid_597091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597092: Call_SubscriptionRegeneratePrimaryKey_597084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates primary key of existing subscription of the API Management service instance.
  ## 
  let valid = call_597092.validator(path, query, header, formData, body)
  let scheme = call_597092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597092.url(scheme.get, call_597092.host, call_597092.base,
                         call_597092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597092, url, valid)

proc call*(call_597093: Call_SubscriptionRegeneratePrimaryKey_597084;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          sid: string; serviceName: string): Recallable =
  ## subscriptionRegeneratePrimaryKey
  ## Regenerates primary key of existing subscription of the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597094 = newJObject()
  var query_597095 = newJObject()
  add(path_597094, "resourceGroupName", newJString(resourceGroupName))
  add(query_597095, "api-version", newJString(apiVersion))
  add(path_597094, "subscriptionId", newJString(subscriptionId))
  add(path_597094, "sid", newJString(sid))
  add(path_597094, "serviceName", newJString(serviceName))
  result = call_597093.call(path_597094, query_597095, nil, nil, nil)

var subscriptionRegeneratePrimaryKey* = Call_SubscriptionRegeneratePrimaryKey_597084(
    name: "subscriptionRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions/{sid}/regeneratePrimaryKey",
    validator: validate_SubscriptionRegeneratePrimaryKey_597085, base: "",
    url: url_SubscriptionRegeneratePrimaryKey_597086, schemes: {Scheme.Https})
type
  Call_SubscriptionRegenerateSecondaryKey_597096 = ref object of OpenApiRestCall_596457
proc url_SubscriptionRegenerateSecondaryKey_597098(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid"),
               (kind: ConstantSegment, value: "/regenerateSecondaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionRegenerateSecondaryKey_597097(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates secondary key of existing subscription of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: JString (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597099 = path.getOrDefault("resourceGroupName")
  valid_597099 = validateParameter(valid_597099, JString, required = true,
                                 default = nil)
  if valid_597099 != nil:
    section.add "resourceGroupName", valid_597099
  var valid_597100 = path.getOrDefault("subscriptionId")
  valid_597100 = validateParameter(valid_597100, JString, required = true,
                                 default = nil)
  if valid_597100 != nil:
    section.add "subscriptionId", valid_597100
  var valid_597101 = path.getOrDefault("sid")
  valid_597101 = validateParameter(valid_597101, JString, required = true,
                                 default = nil)
  if valid_597101 != nil:
    section.add "sid", valid_597101
  var valid_597102 = path.getOrDefault("serviceName")
  valid_597102 = validateParameter(valid_597102, JString, required = true,
                                 default = nil)
  if valid_597102 != nil:
    section.add "serviceName", valid_597102
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597103 = query.getOrDefault("api-version")
  valid_597103 = validateParameter(valid_597103, JString, required = true,
                                 default = nil)
  if valid_597103 != nil:
    section.add "api-version", valid_597103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597104: Call_SubscriptionRegenerateSecondaryKey_597096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates secondary key of existing subscription of the API Management service instance.
  ## 
  let valid = call_597104.validator(path, query, header, formData, body)
  let scheme = call_597104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597104.url(scheme.get, call_597104.host, call_597104.base,
                         call_597104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597104, url, valid)

proc call*(call_597105: Call_SubscriptionRegenerateSecondaryKey_597096;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          sid: string; serviceName: string): Recallable =
  ## subscriptionRegenerateSecondaryKey
  ## Regenerates secondary key of existing subscription of the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597106 = newJObject()
  var query_597107 = newJObject()
  add(path_597106, "resourceGroupName", newJString(resourceGroupName))
  add(query_597107, "api-version", newJString(apiVersion))
  add(path_597106, "subscriptionId", newJString(subscriptionId))
  add(path_597106, "sid", newJString(sid))
  add(path_597106, "serviceName", newJString(serviceName))
  result = call_597105.call(path_597106, query_597107, nil, nil, nil)

var subscriptionRegenerateSecondaryKey* = Call_SubscriptionRegenerateSecondaryKey_597096(
    name: "subscriptionRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions/{sid}/regenerateSecondaryKey",
    validator: validate_SubscriptionRegenerateSecondaryKey_597097, base: "",
    url: url_SubscriptionRegenerateSecondaryKey_597098, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
