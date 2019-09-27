
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ManagementLinkClient
## version: 2016-09-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure resources can be linked together to form logical relationships. You can establish links between resources belonging to different resource groups. However, all the linked resources must belong to the same subscription. Each resource can be linked to 50 other resources. If any of the linked resources are deleted or moved, the link owner must clean up the remaining link.
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  macServiceName = "resources-links"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593630 = ref object of OpenApiRestCall_593408
proc url_OperationsList_593632(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593631(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Microsoft.Resources REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593791 = query.getOrDefault("api-version")
  valid_593791 = validateParameter(valid_593791, JString, required = true,
                                 default = nil)
  if valid_593791 != nil:
    section.add "api-version", valid_593791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593814: Call_OperationsList_593630; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.Resources REST API operations.
  ## 
  let valid = call_593814.validator(path, query, header, formData, body)
  let scheme = call_593814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593814.url(scheme.get, call_593814.host, call_593814.base,
                         call_593814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593814, url, valid)

proc call*(call_593885: Call_OperationsList_593630; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Microsoft.Resources REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var query_593886 = newJObject()
  add(query_593886, "api-version", newJString(apiVersion))
  result = call_593885.call(nil, query_593886, nil, nil, nil)

var operationsList* = Call_OperationsList_593630(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Resources/operations",
    validator: validate_OperationsList_593631, base: "", url: url_OperationsList_593632,
    schemes: {Scheme.Https})
type
  Call_ResourceLinksListAtSubscription_593926 = ref object of OpenApiRestCall_593408
proc url_ResourceLinksListAtSubscription_593928(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Resources/links")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceLinksListAtSubscription_593927(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the linked resources for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593944 = path.getOrDefault("subscriptionId")
  valid_593944 = validateParameter(valid_593944, JString, required = true,
                                 default = nil)
  if valid_593944 != nil:
    section.add "subscriptionId", valid_593944
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the list resource links operation. The supported filter for list resource links is targetId. For example, $filter=targetId eq {value}
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593945 = query.getOrDefault("api-version")
  valid_593945 = validateParameter(valid_593945, JString, required = true,
                                 default = nil)
  if valid_593945 != nil:
    section.add "api-version", valid_593945
  var valid_593946 = query.getOrDefault("$filter")
  valid_593946 = validateParameter(valid_593946, JString, required = false,
                                 default = nil)
  if valid_593946 != nil:
    section.add "$filter", valid_593946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593947: Call_ResourceLinksListAtSubscription_593926;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the linked resources for the subscription.
  ## 
  let valid = call_593947.validator(path, query, header, formData, body)
  let scheme = call_593947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593947.url(scheme.get, call_593947.host, call_593947.base,
                         call_593947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593947, url, valid)

proc call*(call_593948: Call_ResourceLinksListAtSubscription_593926;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## resourceLinksListAtSubscription
  ## Gets all the linked resources for the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the list resource links operation. The supported filter for list resource links is targetId. For example, $filter=targetId eq {value}
  var path_593949 = newJObject()
  var query_593950 = newJObject()
  add(query_593950, "api-version", newJString(apiVersion))
  add(path_593949, "subscriptionId", newJString(subscriptionId))
  add(query_593950, "$filter", newJString(Filter))
  result = call_593948.call(path_593949, query_593950, nil, nil, nil)

var resourceLinksListAtSubscription* = Call_ResourceLinksListAtSubscription_593926(
    name: "resourceLinksListAtSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/links",
    validator: validate_ResourceLinksListAtSubscription_593927, base: "",
    url: url_ResourceLinksListAtSubscription_593928, schemes: {Scheme.Https})
type
  Call_ResourceLinksCreateOrUpdate_593960 = ref object of OpenApiRestCall_593408
proc url_ResourceLinksCreateOrUpdate_593962(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceLinksCreateOrUpdate_593961(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a resource link between the specified resources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   linkId: JString (required)
  ##         : The fully qualified ID of the resource link. Use the format, 
  ## /subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/{provider-namespace}/{resource-type}/{resource-name}/Microsoft.Resources/links/{link-name}. For example, 
  ## /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup/Microsoft.Web/sites/mySite/Microsoft.Resources/links/myLink
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `linkId` field"
  var valid_593980 = path.getOrDefault("linkId")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "linkId", valid_593980
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593981 = query.getOrDefault("api-version")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "api-version", valid_593981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for creating or updating a resource link.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593983: Call_ResourceLinksCreateOrUpdate_593960; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a resource link between the specified resources.
  ## 
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_ResourceLinksCreateOrUpdate_593960;
          apiVersion: string; parameters: JsonNode; linkId: string): Recallable =
  ## resourceLinksCreateOrUpdate
  ## Creates or updates a resource link between the specified resources.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   parameters: JObject (required)
  ##             : Parameters for creating or updating a resource link.
  ##   linkId: string (required)
  ##         : The fully qualified ID of the resource link. Use the format, 
  ## /subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/{provider-namespace}/{resource-type}/{resource-name}/Microsoft.Resources/links/{link-name}. For example, 
  ## /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup/Microsoft.Web/sites/mySite/Microsoft.Resources/links/myLink
  var path_593985 = newJObject()
  var query_593986 = newJObject()
  var body_593987 = newJObject()
  add(query_593986, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_593987 = parameters
  add(path_593985, "linkId", newJString(linkId))
  result = call_593984.call(path_593985, query_593986, nil, nil, body_593987)

var resourceLinksCreateOrUpdate* = Call_ResourceLinksCreateOrUpdate_593960(
    name: "resourceLinksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{linkId}",
    validator: validate_ResourceLinksCreateOrUpdate_593961, base: "",
    url: url_ResourceLinksCreateOrUpdate_593962, schemes: {Scheme.Https})
type
  Call_ResourceLinksGet_593951 = ref object of OpenApiRestCall_593408
proc url_ResourceLinksGet_593953(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceLinksGet_593952(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a resource link with the specified ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   linkId: JString (required)
  ##         : The fully qualified Id of the resource link. For example, 
  ## /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup/Microsoft.Web/sites/mySite/Microsoft.Resources/links/myLink
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `linkId` field"
  var valid_593954 = path.getOrDefault("linkId")
  valid_593954 = validateParameter(valid_593954, JString, required = true,
                                 default = nil)
  if valid_593954 != nil:
    section.add "linkId", valid_593954
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593955 = query.getOrDefault("api-version")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "api-version", valid_593955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593956: Call_ResourceLinksGet_593951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource link with the specified ID.
  ## 
  let valid = call_593956.validator(path, query, header, formData, body)
  let scheme = call_593956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593956.url(scheme.get, call_593956.host, call_593956.base,
                         call_593956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593956, url, valid)

proc call*(call_593957: Call_ResourceLinksGet_593951; apiVersion: string;
          linkId: string): Recallable =
  ## resourceLinksGet
  ## Gets a resource link with the specified ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   linkId: string (required)
  ##         : The fully qualified Id of the resource link. For example, 
  ## /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup/Microsoft.Web/sites/mySite/Microsoft.Resources/links/myLink
  var path_593958 = newJObject()
  var query_593959 = newJObject()
  add(query_593959, "api-version", newJString(apiVersion))
  add(path_593958, "linkId", newJString(linkId))
  result = call_593957.call(path_593958, query_593959, nil, nil, nil)

var resourceLinksGet* = Call_ResourceLinksGet_593951(name: "resourceLinksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{linkId}",
    validator: validate_ResourceLinksGet_593952, base: "",
    url: url_ResourceLinksGet_593953, schemes: {Scheme.Https})
type
  Call_ResourceLinksDelete_593988 = ref object of OpenApiRestCall_593408
proc url_ResourceLinksDelete_593990(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceLinksDelete_593989(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a resource link with the specified ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   linkId: JString (required)
  ##         : The fully qualified ID of the resource link. Use the format, 
  ## /subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/{provider-namespace}/{resource-type}/{resource-name}/Microsoft.Resources/links/{link-name}. For example, 
  ## /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup/Microsoft.Web/sites/mySite/Microsoft.Resources/links/myLink
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `linkId` field"
  var valid_593991 = path.getOrDefault("linkId")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "linkId", valid_593991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593992 = query.getOrDefault("api-version")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "api-version", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_ResourceLinksDelete_593988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a resource link with the specified ID.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_ResourceLinksDelete_593988; apiVersion: string;
          linkId: string): Recallable =
  ## resourceLinksDelete
  ## Deletes a resource link with the specified ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   linkId: string (required)
  ##         : The fully qualified ID of the resource link. Use the format, 
  ## /subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/{provider-namespace}/{resource-type}/{resource-name}/Microsoft.Resources/links/{link-name}. For example, 
  ## /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup/Microsoft.Web/sites/mySite/Microsoft.Resources/links/myLink
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(query_593996, "api-version", newJString(apiVersion))
  add(path_593995, "linkId", newJString(linkId))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var resourceLinksDelete* = Call_ResourceLinksDelete_593988(
    name: "resourceLinksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{linkId}",
    validator: validate_ResourceLinksDelete_593989, base: "",
    url: url_ResourceLinksDelete_593990, schemes: {Scheme.Https})
type
  Call_ResourceLinksListAtSourceScope_593997 = ref object of OpenApiRestCall_593408
proc url_ResourceLinksListAtSourceScope_593999(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/links")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceLinksListAtSourceScope_593998(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of resource links at and below the specified source scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The fully qualified ID of the scope for getting the resource links. For example, to list resource links at and under a resource group, set the scope to /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_594000 = path.getOrDefault("scope")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "scope", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply when getting resource links. To get links only at the specified scope (not below the scope), use Filter.atScope().
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  var valid_594015 = query.getOrDefault("$filter")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = newJString("atScope()"))
  if valid_594015 != nil:
    section.add "$filter", valid_594015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594016: Call_ResourceLinksListAtSourceScope_593997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of resource links at and below the specified source scope.
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_ResourceLinksListAtSourceScope_593997;
          apiVersion: string; scope: string; Filter: string = "atScope()"): Recallable =
  ## resourceLinksListAtSourceScope
  ## Gets a list of resource links at and below the specified source scope.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   scope: string (required)
  ##        : The fully qualified ID of the scope for getting the resource links. For example, to list resource links at and under a resource group, set the scope to /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup.
  ##   Filter: string
  ##         : The filter to apply when getting resource links. To get links only at the specified scope (not below the scope), use Filter.atScope().
  var path_594018 = newJObject()
  var query_594019 = newJObject()
  add(query_594019, "api-version", newJString(apiVersion))
  add(path_594018, "scope", newJString(scope))
  add(query_594019, "$filter", newJString(Filter))
  result = call_594017.call(path_594018, query_594019, nil, nil, nil)

var resourceLinksListAtSourceScope* = Call_ResourceLinksListAtSourceScope_593997(
    name: "resourceLinksListAtSourceScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Resources/links",
    validator: validate_ResourceLinksListAtSourceScope_593998, base: "",
    url: url_ResourceLinksListAtSourceScope_593999, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
